#1/bin/bash


# phantomjs --webdriver=2816 1>/dev/null &


echo '##################################################################'
echo '################# create rhcsa menu widget #######################'
echo '##################################################################'
category_id=`wp term list category --path=/var/www/html/ | grep rhcsa | cut -d' ' -f2`
#wp widget add calendar left 1 --title="Calendar" --path=/var/www/html/
#wp widget list left --path=/var/www/html/


su -s /bin/bash apache -c 'wp plugin install custom-menu-wizard --activate --path=/var/www/html/'

ruby /root/wordpress-codingbee/scripts/selenium-scripts/dummy.rb ${wp_web_admin_username} ${wp_web_admin_user_password}
echo '##################################################################'
echo '###### running import_all_impex_plugin_templates.rb script #######'
echo '##################################################################'
ruby /root/wordpress-codingbee/scripts/selenium-scripts/import_all_impex_plugin_templates.rb ${wp_web_admin_username} ${wp_web_admin_user_password}
echo '##################################################################'
echo '############### running import_posts.rb script ###################'
echo '##################################################################'
ruby /root/wordpress-codingbee/scripts/selenium-scripts/import_posts.rb ${wp_web_admin_username} ${wp_web_admin_user_password}


# sleep 10
# pkill phantomjs
