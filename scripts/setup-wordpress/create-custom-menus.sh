#!/bin/bash

systemctl stop httpd
sleep 10
systemctl start httpd

#phantomjs --webdriver=2816 1>/dev/null &
sleep 10

wp widget reset left --path=/var/www/html/
# wp widget deactivate recent-posts-2 --path=/var/www/html/
# wp widget deactivate search-2 --path=/var/www/html/
# wp widget deactivate recent-comments-2 --path=/var/www/html/
# wp widget deactivate archives-2 --path=/var/www/html/
# wp widget deactivate meta-2 --path=/var/www/html/
# wp widget deactivate categories-2 --path=/var/www/html/

cd /root/wordpress-codingbee/scripts/selenium-scripts

set -x


echo '##################################################################'
echo '############## About to create RHCSA custom menu #################'
echo '##################################################################'
/root/wordpress-codingbee/scripts/create-menu.sh rhcsa

#wp sidebar list --path=/var/www/html/
wp widget add nav_menu left 1 --title="RHCSA" --path=/var/www/html/

dropdown_menu_html_id=$(wp widget list left --path=/var/www/html/ --fields=id,options --format=csv | grep -i rhcsa | cut -d',' -f1)
category_html_id=$(wp term list category --path=/var/www/html/ --fields=term_id,slug --format=csv | grep -i rhcsa | cut -d',' -f1)
# wp widget update ${dropdown_menu_html_id} --title='RHCSA' --cat-${category_html_id}=1 --dw_include=1 --dw_logged="" --other_ids="" --path=/var/www/html/
xvfb-run python3.6 configure-widget.py s ${wp_web_admin_username} ${wp_web_admin_user_password} RHCSA rhcsa ${dropdown_menu_html_id} ${category_html_id}

echo '##################################################################'
echo '############## About to create csharp custom menu ################'
echo '##################################################################'

/root/wordpress-codingbee/scripts/create-menu.sh csharp
wp widget add nav_menu left 1 --title="csharp" --path=/var/www/html/
dropdown_menu_html_id=$(wp widget list left --path=/var/www/html/ --fields=id,options --format=csv | grep -i csharp | cut -d',' -f1)
category_html_id=$(wp term list category --path=/var/www/html/ --fields=term_id,slug --format=csv | grep -i csharp | cut -d',' -f1)
xvfb-run python3.6 configure-widget.py s ${wp_web_admin_username} ${wp_web_admin_user_password} csharp csharp ${dropdown_menu_html_id} ${category_html_id}

echo '##################################################################'
echo '############ About to create Powershell custom menu ##############'
echo '##################################################################'

/root/wordpress-codingbee/scripts/create-menu.sh powershell
wp widget add nav_menu left 1 --title="powershell" --path=/var/www/html/
dropdown_menu_html_id=$(wp widget list left --path=/var/www/html/ --fields=id,options --format=csv | grep -i powershell | cut -d',' -f1)
category_html_id=$(wp term list category --path=/var/www/html/ --fields=term_id,slug --format=csv | grep -i powershell | cut -d',' -f1)
xvfb-run python3.6 configure-widget.py s ${wp_web_admin_username} ${wp_web_admin_user_password} powershell powershell ${dropdown_menu_html_id} ${category_html_id}


echo '##################################################################'
echo '############## About to create Puppet custom menu ################'
echo '##################################################################'


/root/wordpress-codingbee/scripts/create-menu.sh puppet
wp widget add nav_menu left 1 --title="puppet" --path=/var/www/html/
dropdown_menu_html_id=$(wp widget list left --path=/var/www/html/ --fields=id,options --format=csv | grep -i puppet | cut -d',' -f1)
category_html_id=$(wp term list category --path=/var/www/html/ --fields=term_id,slug --format=csv | grep -i puppet | cut -d',' -f1)
xvfb-run python3.6 configure-widget.py s ${wp_web_admin_username} ${wp_web_admin_user_password} puppet puppet ${dropdown_menu_html_id} ${category_html_id}


echo '##################################################################'
echo '############## About to create ruby custom menu ################'
echo '##################################################################'


/root/wordpress-codingbee/scripts/create-menu.sh ruby
wp widget add nav_menu left 1 --title="ruby" --path=/var/www/html/
dropdown_menu_html_id=$(wp widget list left --path=/var/www/html/ --fields=id,options --format=csv | grep -i ruby | cut -d',' -f1)
category_html_id=$(wp term list category --path=/var/www/html/ --fields=term_id,slug --format=csv | grep -i ruby | cut -d',' -f1)
xvfb-run python3.6 configure-widget.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ruby ruby ${dropdown_menu_html_id} ${category_html_id}


echo '##################################################################'
echo '############## About to create vagrant custom menu ################'
echo '##################################################################'


/root/wordpress-codingbee/scripts/create-menu.sh vagrant
wp widget add nav_menu left 1 --title="vagrant" --path=/var/www/html/
dropdown_menu_html_id=$(wp widget list left --path=/var/www/html/ --fields=id,options --format=csv | grep -i vagrant | cut -d',' -f1)
category_html_id=$(wp term list category --path=/var/www/html/ --fields=term_id,slug --format=csv | grep -i vagrant | cut -d',' -f1)
xvfb-run python3.6 configure-widget.py s ${wp_web_admin_username} ${wp_web_admin_user_password} vagrant vagrant ${dropdown_menu_html_id} ${category_html_id}



echo '##################################################################'
echo '############## About to create git custom menu ################'
echo '##################################################################'


/root/wordpress-codingbee/scripts/create-menu.sh git
wp widget add nav_menu left 1 --title="git" --path=/var/www/html/
dropdown_menu_html_id=$(wp widget list left --path=/var/www/html/ --fields=id,options --format=csv | grep -i git | cut -d',' -f1)
category_html_id=$(wp term list category --path=/var/www/html/ --fields=term_id,slug --format=csv | grep -i git | cut -d',' -f1)
xvfb-run python3.6 configure-widget.py s ${wp_web_admin_username} ${wp_web_admin_user_password} git git ${dropdown_menu_html_id} ${category_html_id}



echo '##################################################################'
echo '############## About to create ansible custom menu ################'
echo '##################################################################'


/root/wordpress-codingbee/scripts/create-menu.sh ansible
wp widget add nav_menu left 1 --title="ansible" --path=/var/www/html/
dropdown_menu_html_id=$(wp widget list left --path=/var/www/html/ --fields=id,options --format=csv | grep -i ansible | cut -d',' -f1)
category_html_id=$(wp term list category --path=/var/www/html/ --fields=term_id,slug --format=csv | grep -i ansible | cut -d',' -f1)
xvfb-run python3.6 configure-widget.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ansible ansible ${dropdown_menu_html_id} ${category_html_id}



echo '##################################################################'
echo '############## About to create python custom menu ################'
echo '##################################################################'


/root/wordpress-codingbee/scripts/create-menu.sh python
wp widget add nav_menu left 1 --title="python" --path=/var/www/html/
dropdown_menu_html_id=$(wp widget list left --path=/var/www/html/ --fields=id,options --format=csv | grep -i python | cut -d',' -f1)
category_html_id=$(wp term list category --path=/var/www/html/ --fields=term_id,slug --format=csv | grep -i python | cut -d',' -f1)
xvfb-run python3.6 configure-widget.py s ${wp_web_admin_username} ${wp_web_admin_user_password} python python ${dropdown_menu_html_id} ${category_html_id}





echo '##################################################################'
echo '############## About to create tutorials custom menu ################'
echo '##################################################################'


/root/wordpress-codingbee/scripts/create-menu.sh tutorials
wp widget add nav_menu left 1 --title="Available Tutorials" --path=/var/www/html/



set +x

#/root/wordpress-codingbee/scripts/create-menu.sh tutorials

pkill phantomjs
