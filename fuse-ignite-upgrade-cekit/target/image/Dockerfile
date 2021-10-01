
# This is a Dockerfile for the fuse7/fuse-online-meta-rhel8:1.9 image.


## START target image fuse7/fuse-online-meta-rhel8:1.9
## \
    FROM registry-proxy.engineering.redhat.com/rh-osbs/ubi8-openjdk-8


    USER root

###### START module 'environ:1.0'
###### \
        # Set 'environ' module defined environment variables
        ENV \
            COMMUNITY_VERSION="1.12" \
            KUBECONFIG="/opt/kube-config" \
            RELEASE="1" \
            SYNDESIS_CLI_VERSION="1.12.0.fuse-790010-redhat-00001" \
            SYNDESIS_VERSION="1.5" 
###### /
###### END module 'environ:1.0'

###### START module 'install-pkg:1.0'
###### \
        # Copy 'install-pkg' module content
        COPY modules/install-pkg /tmp/scripts/install-pkg
        # Custom scripts from 'install-pkg' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/install-pkg/install.sh" ]
###### /
###### END module 'install-pkg:1.0'

###### START module 'license:1.0'
###### \
        # Copy 'license' module content
        COPY modules/license /tmp/scripts/license
        # Custom scripts from 'license' module
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/license/configure.sh" ]
        USER root
        RUN [ "sh", "-x", "/tmp/scripts/license/backward_compatibility.sh" ]
###### /
###### END module 'license:1.0'

###### START image 'fuse7/fuse-online-meta-rhel8:1.9'
###### \
        # Copy 'fuse7/fuse-online-meta-rhel8' image general artifacts to '/opt/' destination
        COPY \
            upgrade.sh \
            common.sh \
            entrypoint.sh \
            syndesis-cli.jar \
            /opt/
        # Copy 'fuse7/fuse-online-meta-rhel8' image general artifacts to '/opt/migration/' destination
        COPY \
            migration \
            /opt/migration/
        # Copy 'fuse7/fuse-online-meta-rhel8' image general artifacts to '/opt/steps/' destination
        COPY \
            steps \
            /opt/steps/
        # Set 'fuse7/fuse-online-meta-rhel8' image defined labels
        LABEL \
            com.redhat.component="fuse-ignite-upgrade-rhel-8-container"  \
            description="Manages metadata and validation for Fuse Online connectors."  \
            io.cekit.version="3.11.0"  \
            io.k8s.description="Controller that manages updates and upgrade process for Fuse Online components"  \
            io.k8s.display-name="Red Hat Fuse Online - Upgrade"  \
            io.openshift.tags="fuse,online"  \
            maintainer="Otavio Piske <opiske@redhat.com>"  \
            summary="Manages metadata and validation for Fuse Online connectors." 
###### /
###### END image 'fuse7/fuse-online-meta-rhel8:1.9'



    # Switch to 'root' user and remove artifacts and modules
    USER root
    RUN [ ! -d /tmp/scripts ] || rm -rf /tmp/scripts
    RUN [ ! -d /tmp/artifacts ] || rm -rf /tmp/artifacts
    # Define the user
    USER root
    # Define the working directory
    WORKDIR /opt
    # Define entrypoint
    ENTRYPOINT ["/bin/bash", "/opt/upgrade.sh", "--migration", "/opt/migration"]
## /
## END target image