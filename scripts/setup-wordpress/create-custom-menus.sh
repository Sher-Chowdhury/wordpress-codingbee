#!/bin/bash

systemctl stop httpd
sleep 30
systemctl stop httpd
sleep 30

echo '##################################################################'
echo '############## About to create RHCSA custom menu #################'
echo '##################################################################'
/root/wordpress-codingbee/scripts/create-menu.sh rhcsa

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
