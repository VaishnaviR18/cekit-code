/bin/bash
-lc
./build.sh --operator-build go --image-build skip --source-gen skip --image-name registry.redhat.io/fuse7/fuse-online-rhel8-operator --image-tag=${UPGRADE_VERSION}
gzip $REMOTE_SOURCE_DIR/app/install/operator/dist/darwin-amd64/syndesis-operator
gzip $REMOTE_SOURCE_DIR/app/install/operator/dist/windows-amd64/syndesis-operator

