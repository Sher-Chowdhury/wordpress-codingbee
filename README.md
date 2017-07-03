# wordpress-codingbee
Automate the build of a wordpress website on CentOS 7


TO-DO LIST for Aleksandar:


## 1. Activate wordpress licence theme. 
Navigate to:
http://codingbee.net/wp-admin/themes.php?page=tc-licenses
Then following instructions to enter key and activate. 

I need to be able to do this by running the following in my bash shell scripts:

xvfb-run python3.6 install-theme-licence.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ${premium-theme-licence-key}



## 2. Activate wordpress backupbuddy plugin
Navigate to:
http://codingbee.net/wp-admin/options-general.php?page=ithemes-licensing
Then following instructions to enter username and password

I need to be able to do this by running the following in my bash shell scripts:

xvfb-run python3.6 setup-backupbuddy.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ${ithemes-username} ${ithemes-password}




## 3. Activate wpallimport plugin 
Navigate to:
http://codingbee.net/wp-admin/admin.php?page=pmxi-admin-settings
Then enter licence key and save/activate 

I need to be able to do this by running the following in my bash shell scripts:

xvfb-run python3.6 install-wpallimport-licence.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ${wpallimport-licence-key}


## 4. Activate wpallexport plugin 
Navigate to:
http://codingbee.net/wp-admin/admin.php?page=pmxe-admin-settings
Then enter licence key and save/activate 

I need to be able to do this by running the following in my bash shell scripts:

xvfb-run python3.6 install-wpallexport-licence.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ${wpallexport-licence-key}

## 5. upload a file (for tablepress)
Navigate to:
http://codingbee.net/wp-admin/admin.php?page=tablepress_import


file source: File Upload (then go for the 'choose file' button)
import format: json (note I think this will autoupdate to json after you chosen the file to upload)
add, replace, or append: add as new table. 



xvfb-run python3.6 import-tablepress-table.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ${absolute_path_to_json_file}

Note, absolute path will be something like /root/tempfiles/data.json
This file will live on the digital ocean droplet. 



## 6. upload a file (for custom theme settings)
Navigate to: 
Appearance -> Customize

At the bottom, select the "Export/Import" item

Under the import section, import a file. 

xvfb-run python3.6 import-theme-customizater-settings.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ${absolute_path_to_json_file}

Note, absolute path will be something like /root/tempfiles/data.dat
This file will live on the digital ocean droplet. 


## 7. configure a text widget called 'Search'
A text widget called "Search" will exist, and this script will add some text into it (but need to select the 'text' tab first)

xvfb-run python3.6 configure-search-widget.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ${content} 

No further configurations are required. Everything else stays the same. I.e. don't click on any further checkboxes, dropdown list, or tabs. 

