#!/bin/bash

su -s /bin/bash apache -c 'wp core download --path=/var/www/html' || exit 1


su -s /bin/bash apache -c "wp core config --path=/var/www/html --dbname=${wp_db_name} --dbuser=${db_username} --dbpass=${db_password} --extra-php <<PHP
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', true);
define('WP_MEMORY_LIMIT', '256M');
PHP"


su -s /bin/bash apache -c "wp core install --path=/var/www/html --url=\"${url}\" --title=Codingbee --admin_user=${wp_web_admin_username} --admin_password=${wp_web_admin_user_password} --admin_email=YOU@YOURDOMAIN.com"

su -s /bin/bash apache -c "wp option update blogdescription \"End-2-End AWS Infrastructure Automation\" --path=/var/www/html/"

# Here I am defining a wordpress permalink structure
su -s /bin/bash apache -c "wp rewrite structure '/%category%/%postname%' --path=/var/www/html/"

echo '
# the following lines do not appear to work with siteground webhosting company.
#php_value suhosin.post.max_vars 5000
#php_value suhosin.request.max_vars 5000
#php_value memory_limit 256M
#php_value max_execution_time 600
#php_value upload_max_filesize 70M
#php_value post_max_size 128M
#php_value upload_tmp_dir 70M
#php_value max_input_vars 5000


# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>

# END WordPress' > /var/www/html/.htaccess

chown apache:apache /var/www/html/.htaccess


systemctl restart httpd
