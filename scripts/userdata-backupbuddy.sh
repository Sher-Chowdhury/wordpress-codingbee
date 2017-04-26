#!/bin/bash

mkdir /root/downloads  || exit 1
cd /root/downloads || exit 1
curl -L ${dropbox_folder_link} > /root/downloads/download.zip || exit 1
unzip download.zip -x / || exit 1
rm download.zip || exit 1

chown -R apache:apache /root/downloads

cd /root/downloads/premium-plugins/backupbuddy

cp backup-codingbee_net* /var/www/html/
cp importbuddy.php /var/www/html/

chown -R apache:apache /var/www/html/

systemctl restart httpd  || exit 1


exit 0
