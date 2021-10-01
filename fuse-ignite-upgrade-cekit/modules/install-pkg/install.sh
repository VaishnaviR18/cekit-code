#!/bin/sh
set -e

dnf install -y jq \
&& dnf clean all \
&& mkdir /opt/backup \
&& chgrp -R 0 /opt \
&& chmod -R g=u /opt