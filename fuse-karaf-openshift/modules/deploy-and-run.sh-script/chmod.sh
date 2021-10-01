chmod a+x /deployments/deploy-and-run.sh
chmod a+x /usr/local/s2i/*
chmod -R "g+rwX" /deployments
chown -R jboss:root /deployments
chmod -R "g+rwX" /home/jboss
chown -R jboss:root /home/jboss
chmod 664 /etc/passwd

chmod -R "g+rwX" /home/jboss && chown -R jboss:root /home/jboss