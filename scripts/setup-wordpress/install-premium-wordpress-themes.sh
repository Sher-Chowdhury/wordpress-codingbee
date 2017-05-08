#!/bin/bash

mv /root/downloads/premium-themes /var/www/html
cd /var/www/html/premium-themes
su -s /bin/bash apache -c 'wp theme install ./customizr-pro.zip --activate --path=/var/www/html/'
rm -rf /var/www/html/premium-themes
