#!/bin/bash

set -o pipefail
set -eu

BASE_BUILD_URL=${BASE_BUILD_URL:-http://indy.psi.redhat.com/api/content/maven/group/redhat-builds}

display_usage() {
    cat <<EOT
Build script to start the docker build of fuse-ignite-upgrade.

Usage: build-image.sh [options] -s <syndesis-version>

Syndesis version is the redhat version of the syndesis component.
Upgrade version is the major.minor number of the upgrade image, e.g. 1.3
Path is the path to the integration-platform-tooling

Options:

-d, --dry-run     Do not commit any changes, and do not run the build.
    --scratch     When running the build, do a scratch build (only applicable if NOT running in dry-run mode).
-h, --help        This help message

EOT
}

cleanup() {
    rm -f syndesis-cli-*.jar*
}

download() {
    local url=$1
    local filename=`basename $url`

    if [ -f $filename ]
    then
        echo "File $filename already exists. Skipping download."
        return 0
    fi

    echo "Downloading $url"
    wget -q $url
    if [ $? -ne 0 ]
    then
        echo "Error downloading file from $url."
        return 1
    fi

    # See if there is a md5 file
    if [ -f $filename.md5 ]
    then
        rm $filename.md5
    fi

    wget -q $url.md5
    if [ $? -ne 0 ]
    then
        echo "Error downloading file from $url.md5."
        return 1
    fi

    if ! md5sum $filename | cut -d ' ' -f 1 | tr -d '\n' | cmp - $filename.md5
    then
        echo "ERROR: md5sums do not match for $filename"
        return 1
    fi

    return 0

}

extract_minor() {
    local version=$1
    local minor_version=$(echo $version | sed -E -n 's/([0-9]+\.[0-9]+).*/\1/p')
    if [ "$minor_version" = "$version" ]; then
        echo "ERROR: Cannot extract minor version from $version"
        return
    fi
    echo $minor_version
}

checkout_sources() {
    local syndesisVersion=$1

    if [ ! -d syndesis ]
    then
        echo "Cloning syndesis repo"
        if ! git clone -q https://code.engineering.redhat.com/gerrit/syndesisio/syndesis
        then
            echo "ERROR: Failed to clone https://code.engineering.redhat.com/gerrit/syndesisio/syndesis"
            return 1
        fi
    fi

    cd syndesis
    git fetch --tags
    upstreamVersion=${syndesisVersion%*-redhat-*}
    echo "Checking out tag syndesis-$upstreamVersion"
    if ! git checkout -q syndesis-$upstreamVersion
    then
        echo "ERROR: Failed to checkout syndesis-$upstreamVersion tag"
        cd ..
        return 1
    fi

    cd ..

    return 0
}

update_dockerfile() {
    local syndesisVersion=$1
    local dryRun=$2
    local minorVersion=`extract_minor $syndesisVersion`

    echo "Updating Dockerfile"
    sed -i "/^ENV/,/^$/s/\(.*\)SYNDESIS_CLI_VERSION\([ =]\)[0-9a-zA-Z\.-]\+\(.*\)/\1SYNDESIS_CLI_VERSION\2$syndesisVersion\3/" Dockerfile
    sed -i "/^ENV/,/^$/s/\(.*\)COMMUNITY_VERSION\([ =]\)[0-9a-zA-Z\.-]\+\(.*\)/\1COMMUNITY_VERSION\2$minorVersion\3/" Dockerfile

    # Update the RELEASE number
    local release=$(grep RELEASE= Dockerfile | sed 's/RELEASE=\([0-9]\+\) \\/\1/' )
    release=$(($release + 1))
    sed -i "/^ENV/,/^$/s/\(.*\)RELEASE\([ =]\)[0-9a-zA-Z\.-]\+\(.*\)/\1RELEASE\2$release\3/" Dockerfile


    if [ "$dryRun" == "false" ]
    then
        git add Dockerfile
    fi
}

upload_sources() {
    local syndesisVersion=$1

    # Remove existing syndesis-cli artifact from the sources file
    sed -i '/syndesis-cli/d' sources

    # Upload new file
    echo "Uploading syndesis-cli-$syndesisVersion.jar to lookaside cache"
    rhpkg upload syndesis-cli-$syndesisVersion.jar
    return $?
}

osbs_build() {
    local version=$1
    local scratchBuild=$2

    num_files=$(git status --porcelain  | { egrep '^\s?[MADRC]' || true; } | wc -l)
    if ((num_files > 0)) ; then
        echo "Committing $num_files"
        git commit -m"Updated for build of syndesis $version"
        git push
    else
        echo "There are no files to be committed. Skipping commit + push"
    fi

    if [ "$scratchBuild" == "false" ]
    then
        echo "Starting OSBS build"
        rhpkg container-build
    else
        local branch=$(git rev-parse --abbrev-ref HEAD)
        local build_options=""

        # If we are building on a private branch, then we need to use the correct target
        if [[ $branch == *"private"* ]] ; then
            # Remove the private part of the branch name: from private-opiske-fuse-7.4-openshift-rhel-7
            # to fuse-7.4-openshift-rhel-7 and we add the containers candidate to the options
            local target="${branch#*-*-}-containers-candidate"

            build_options="${build_options} --target ${target}"
            echo "Using target ${target} for the private container build"
        fi

        echo "Starting OSBS scratch build"
        rhpkg container-build --scratch ${build_options}
    fi
}

main() {
    SYNDESIS_VERSION=
    DRY_RUN=false
    SCRATCH=false

    # Parse command line arguments
    while [ $# -gt 0 ]
    do
        arg="$1"

        case $arg in
          -h|--help)
            display_usage
            exit 0
            ;;
          -d|--dry-run)
            DRY_RUN=true
            ;;
          --scratch)
            SCRATCH=true
            ;;
          -s|--syndesis)
            shift
            SYNDESIS_VERSION="$1"
            ;;
          *)
            echo "Unknonwn argument: $1"
            display_usage
            exit 1
            ;;
        esac
        shift
    done

    # Check that syndesis version is specified
    if [ -z "$SYNDESIS_VERSION" ]
    then
        echo "ERROR: Syndesis version wasn't specified."
        exit 1
    fi

    # Download Syndesis s2i artifact
    if ! download ${BASE_BUILD_URL}/io/syndesis/server/syndesis-cli/$SYNDESIS_VERSION/syndesis-cli-$SYNDESIS_VERSION.jar
    then
        exit 1
    fi

    update_dockerfile $SYNDESIS_VERSION $DRY_RUN

    if ! upload_sources $SYNDESIS_VERSION
    then
        echo "Error uploading syndesis-cli-$SYNDESIS_VERSION.jar to lookaside cache"
        exit 1
    fi

    if [ "$DRY_RUN" == "false" ]
    then
        osbs_build $SYNDESIS_VERSION $SCRATCH
    fi

    cleanup
}

main $*
