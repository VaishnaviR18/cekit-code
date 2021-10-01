chmod 444 /opt/prometheus/jmx_prometheus_javaagent.jar
chmod 444 /opt/prometheus/prometheus-config.yml
chmod 755 /opt/prometheus/prometheus-opts
chmod 775 /opt/prometheus/etc
chgrp root /opt/prometheus/etc

mkdir -p /opt/jolokia/etc