# wordpress-codingbee
Automate the build of a wordpress website on CentOS 7

## 1. Acitvate wordpress licence theme. 
Navigate to:
http://codingbee.net/wp-admin/themes.php?page=tc-licenses
Then following instructions to enter key and activate. 

I need to be able to do this by running the following in my bash shell scripts:

xvfb-run python3.6 setup-backupbuddy.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ${premium-licence-key}



## 2. Acitvate wordpress backupbuddy plugins. 
Navigate to:
http://codingbee.net/wp-admin/options-general.php?page=ithemes-licensing
Then following instructions to enter username and password

I need to be able to do this by running the following in my bash shell scripts:

xvfb-run python3.6 setup-backupbuddy.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ${ithemes-username} ${ithemes-password}




## 3. Acitvate wordpress licence theme. 
Navigate to:
http://codingbee.net/wp-admin/themes.php?page=tc-licenses
Then following instructions to enter key and activate. 

I need to be able to do this by running the following in my bash shell scripts:

xvfb-run python3.6 setup-backupbuddy.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ${premium-licence-key}
