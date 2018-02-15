#!/usr/bin/env bash
set -ex

echo '##################################################################'
echo '####################### Install php 7 ############################'
echo '##################################################################'

# this is a debug page that lets you view your php settings.
# Just go to www.example.com/php-info.php to see
# all your runtime php settings.
echo '<?php phpinfo(); ?>' > /var/www/html/php-info.php

chown apache:apache /var/www/html/php-info.php

php --ini

sed -i 's/^memory_limit.*/memory_limit = 512M/g' /etc/php.ini
sed -i 's/^upload_max_filesize.*/upload_max_filesize = 100M/g' /etc/php.ini
sed -i 's/^post_max_size.*/post_max_size = 200M/g' /etc/php.ini
sed -i 's/^max_execution_time.*/max_execution_time = 300/g' /etc/php.ini


# needed to apply the following otherwise unable to bulk delete lots of posts
echo "LimitRequestLine 81900" >> /etc/httpd/conf/httpd.conf || exit 1


# The following is needed for custom wordpress permalinks to work.
augtool <<-EOF
ls /files/etc/httpd/conf/httpd.conf/Directory[arg='\"/var/www/html\"']/*[self::directive='AllowOverride']
print /files/etc/httpd/conf/httpd.conf/Directory[arg='\"/var/www/html\"']/*[self::directive='AllowOverride']
get /files/etc/httpd/conf/httpd.conf/Directory[arg='\"/var/www/html\"']/*[self::directive='AllowOverride']/arg
set /files/etc/httpd/conf/httpd.conf/Directory[arg='\"/var/www/html\"']/*[self::directive='AllowOverride']/arg ALL
ls /files/etc/httpd/conf/httpd.conf/Directory[arg='\"/var/www/html\"']/*[self::directive='AllowOverride']
print /files/etc/httpd/conf/httpd.conf/Directory[arg='\"/var/www/html\"']/*[self::directive='AllowOverride']
get /files/etc/httpd/conf/httpd.conf/Directory[arg='\"/var/www/html\"']/*[self::directive='AllowOverride']/arg
save
quit
EOF
systemctl restart httpd || exit 1
