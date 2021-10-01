#!/bin/sh
# Configure module
set -e

mkdir -p /home/jboss/.m2

SCRIPT_DIR=$(dirname $0)
SETTINGS_DIR=${SCRIPT_DIR}/settings

#chown -R jboss:root $SCRIPT_DIR
chmod -R ug+rwX $SCRIPT_DIR
chmod ug+x ${SETTINGS_DIR}/*

pushd ${SETTINGS_DIR}
cp -pr * /
popd