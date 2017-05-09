#1/bin/bash

phantomjs --webdriver=2816 1>/dev/null &
sleep 10
pkill phantomjs

phantomjs --webdriver=2816 1>/dev/null &


echo '##################################################################'
echo '################# running dummy.rb script ########################'
echo '##################################################################'
ruby /root/wordpress-codingbee/scripts/selenium-scripts/dummy.rb ${wp_web_admin_username} ${wp_web_admin_user_password}
echo '##################################################################'
echo '###### running import_all_impex_plugin_templates.rb script #######'
echo '##################################################################'
ruby /root/wordpress-codingbee/scripts/selenium-scripts/import_all_impex_plugin_templates.rb ${wp_web_admin_username} ${wp_web_admin_user_password}
echo '##################################################################'
echo '############### running import_posts.rb script ###################'
echo '##################################################################'
ruby /root/wordpress-codingbee/scripts/selenium-scripts/import_posts.rb ${wp_web_admin_username} ${wp_web_admin_user_password}
sleep 10
pkill phantomjs

# rm /var/www/html/codingbee-posts-exports.zip
# rm /var/www/html/codingbee-pages-exports.zip

cp /root/wordpress-codingbee/scripts/content_correction_fix.php /var/www/html

sed -i "s/USERNAME/$db_username/g" /var/www/html/content_correction_fix.php
sed -i "s/PASSWORD/$db_password/g" /var/www/html/content_correction_fix.php
sed -i "s/DATABASENAME/$wp_db_name/g" /var/www/html/content_correction_fix.php

cp /root/downloads/wp-all-import-exports/codingbee-posts-exports.zip /var/www/html/
cd /var/www/html/
unzip /var/www/html/codingbee-posts-exports.zip
cp /var/www/html/bundle/codingbee-posts-exports.xml /var/www/html/
chown -R apache:apache /var/www/html/




curl http://localhost/content_correction_fix.php

. ~/wordpress-codingbee/scripts/remove-special-characters-from-mysql.sh ${wp_db_name}

systemctl restart httpd
