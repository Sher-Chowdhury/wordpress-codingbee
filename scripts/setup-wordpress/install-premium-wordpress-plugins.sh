#!/bin/bash

mkdir /root/downloads  || exit 1
cd /root/downloads || exit 1
curl -L ${dropbox_folder_link} > /root/downloads/download.zip || exit 1
unzip download.zip -x / || exit 1
rm download.zip || exit 1

chown -R apache:apache /root/downloads

mv /root/downloads/premium-plugins /var/www/html
cd /var/www/html/premium-plugins
su -s /bin/bash apache -c 'wp plugin install ./backupbuddy/backupbuddy.zip --activate --path=/var/www/html/'

su -s /bin/bash apache -c 'wp plugin install ./wp-all-export-pro.zip --activate --path=/var/www/html/'

su -s /bin/bash apache -c 'wp plugin install ./wp-all-import-pro.zip --activate --path=/var/www/html/'
#rm -rf /root/downloads/premium-plugins
