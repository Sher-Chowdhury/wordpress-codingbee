#!/bin/bash


cd /root/wordpress-codingbee/tablepress

for file in $(ls) ; do

  echo "about to process tabelpress file /root/wordpress-codingbee/tablepress/${file}"

  xvfb-run python3.6 import-tabelpress-files.py s ${wp_web_admin_username} ${wp_web_admin_user_password} /root/wordpress-codingbee/tablepress/${file} 


done

