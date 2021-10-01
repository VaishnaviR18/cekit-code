#!/bin/bash

CURRENT_RELEASE=$(cat Dockerfile | grep RELEASE | awk -F '=' '{ print $2 }' | sed -s 's/ *\\//')
NEXT_RELEASE=$(cat Dockerfile | grep RELEASE | awk -F '=' ' { print $2 }' | sed -s 's/  *\\//' | perl -pe 's/(\d+)/$1+1/eg')
SYNDESIS_VERSION=$(cat Dockerfile | grep SYNDESIS_VERSION | awk -F '=' '{ print $2 }' | sed -s 's/ *\\//')

echo "${SYNDESIS_VERSION}-${CURRENT_RELEASE} will be incremented to ${SYNDESIS_VERSION}-${NEXT_RELEASE}"

echo "Updating docker file"
sed -e "s/RELEASE=$CURRENT_RELEASE/RELEASE=$NEXT_RELEASE/" -i Dockerfile

echo "Updating Syndesis configuration file"
echo sed -e "s/syndesis-upgrade-${SYNDESIS_VERSION}-${CURRENT_RELEASE}/syndesis-upgrade-${SYNDESIS_VERSION}-${NEXT_RELEASE}/g" -e "s/fuse-ignite-upgrade:${SYNDESIS_VERSION}-${CURRENT_RELEASE}/fuse-ignite-upgrade:${SYNDESIS_VERSION}-${NEXT_RELEASE}/g" -i syndesis.yml

echo "CURRENT_RELEASE=$CURRENT_RELEASE" > version.properties
echo "NEXT_RELEASE=$NEXT_RELEASE" >> version.properties
echo "SYNDESIS_VERSION=$SYNDESIS_VERSION" >> version.properties

echo "SYNDESIS_VERSION=$SYNDESIS_VERSION"
echo "CURRENT_RELEASE=$CURRENT_RELEASE"
echo "NEXT_RELEASE=$NEXT_RELEASE"