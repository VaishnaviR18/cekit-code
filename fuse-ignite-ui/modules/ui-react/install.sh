#!/bin/sh
set -e

pushd /tmp/src/; tar -xvf ui-react-$SYNDESIS_VERSION-dist.tar.gz; popd
rm /tmp/src/ui-react-$SYNDESIS_VERSION-dist.tar.gz