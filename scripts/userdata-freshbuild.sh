#!/bin/bash


. ~/wordpress-codingbee/scripts/setup-wordpress/install-wp-cli.sh
. ~/wordpress-codingbee/scripts/setup-wordpress/install-and-configure-wordpress.sh
. ~/wordpress-codingbee/scripts/setup-wordpress/create-wordpress-users.sh
. ~/wordpress-codingbee/scripts/setup-wordpress/install-free-wordpress-plugins.sh
. ~/wordpress-codingbee/scripts/setup-wordpress/install-premium-wordpress-plugins.sh
. ~/wordpress-codingbee/scripts/setup-wordpress/install-premium-wordpress-themes.sh
. ~/wordpress-codingbee/scripts/setup-wordpress/create-wordpress-categories.sh
. ~/wordpress-codingbee/scripts/setup-wordpress/install-selenium.sh






cp /root/downloads/wp-all-import-exports/codingbee-posts-exports.zip /var/www/html/



phantomjs --webdriver=2816 1>/dev/null &
ruby /root/wordpress-codingbee/scripts/dummy.rb
ruby /root/wordpress-codingbee/scripts/import_all_impex_plugin_templates.rb
ruby /root/wordpress-codingbee/scripts/import_posts.rb
sleep 10
pkill phantomjs

# rm /var/www/html/codingbee-posts-exports.zip
# rm /var/www/html/codingbee-pages-exports.zip

cp /root/wordpress-codingbee/scripts/content_correction_fix.php /var/www/html

sed -i "s/USERNAME/$db_username/g" /var/www/html/content_correction_fix.php
sed -i "s/PASSWORD/$db_password/g" /var/www/html/content_correction_fix.php
sed -i "s/DATABASENAME/$wp_db_name/g" /var/www/html/content_correction_fix.php

cd /var/www/html/
unzip /var/www/html/codingbee-posts-exports.zip
cp /var/www/html/bundle/codingbee-posts-exports.xml /var/www/html/
chown -R apache:apache /var/www/html/

curl http://localhost/content_correction_fix.php

. ~/wordpress-codingbee/scripts/remove-special-characters-from-mysql.sh ${wp_db_name}

systemctl restart httpd

#/root/wordpress-codingbee/scripts/create-menu.sh rhcsa
#/root/wordpress-codingbee/scripts/create-menu.sh csharp
#/root/wordpress-codingbee/scripts/create-menu.sh powershell
#/root/wordpress-codingbee/scripts/create-menu.sh puppet
#/root/wordpress-codingbee/scripts/create-menu.sh tutorials
