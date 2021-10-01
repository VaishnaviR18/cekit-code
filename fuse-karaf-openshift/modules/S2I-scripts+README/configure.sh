#!/bin/sh
# Configure module
set -e

rm /usr/local/s2i/scl-enable-maven && chmod 755 /usr/local/s2i/*

SCRIPT_DIR=$(dirname $0)
README_DIR=${SCRIPT_DIR}/README

#chown -R jboss:root $SCRIPT_DIR
chmod -R ug+rwX $SCRIPT_DIR
chmod ug+x ${README_DIR}/*

pushd ${README_DIR}
cp -pr * /
popd