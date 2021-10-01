/bin/bash
-lc
mkdir -p github.com/wrouesnel
cp -r $REMOTE_SOURCE_DIR/app github.com/wrouesnel/postgres_exporter
cd github.com/wrouesnel/postgres_exporter
GOPATH=/opt/app-root VERSION_SHORT=$POSTGRES_EXPORTER_VERSION go run mage.go release
cp bin/postgres_exporter_${POSTGRES_EXPORTER_VERSION}_linux-amd64/postgres_exporter $SRCDIR