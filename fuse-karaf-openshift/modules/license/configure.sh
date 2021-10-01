#!/bin/sh
# Configure module
set -e

mkdir -p /opt/fuse/licenses

SCRIPT_DIR=$(dirname $0)
ARTIFACTS_DIR=${SCRIPT_DIR}/artifacts

#chown -R jboss:root $SCRIPT_DIR
chmod -R ug+rwX $SCRIPT_DIR
chmod ug+x ${ARTIFACTS_DIR}/*

pushd ${ARTIFACTS_DIR}
cp -pr * /opt/fuse/licenses
popd