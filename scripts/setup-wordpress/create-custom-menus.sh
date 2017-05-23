#!/bin/bash

systemctl stop httpd
sleep 10
systemctl start httpd
sleep 30

echo '##################################################################'
echo '############## About to create RHCSA custom menu #################'
echo '##################################################################'
/root/wordpress-codingbee/scripts/create-menu.sh rhcsa

#wp sidebar list --path=/var/www/html/
wp widget add nav_menu left 1 --title="RHCSA" --path=/var/www/html/
dropdown_menu_html_id=$(wp widget list left --path=/var/www/html/ --fields=id,options --format=csv | grep -i rhcsa | cut -d',' -f1)

echo '##################################################################'
echo '############## About to create csharp custom menu ################'
echo '##################################################################'

#/root/wordpress-codingbee/scripts/create-menu.sh csharp

echo '##################################################################'
echo '############ About to create Powershell custom menu ##############'
echo '##################################################################'

#/root/wordpress-codingbee/scripts/create-menu.sh powershell
#/root/wordpress-codingbee/scripts/create-menu.sh puppet
#/root/wordpress-codingbee/scripts/create-menu.sh tutorials
