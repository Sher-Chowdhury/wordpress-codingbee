#!/bin/bash

# At this point we have a standard LAMP server and we now need to 
# set up a fresh wordpress install and customize it. 

echo '##################################################################'
echo '####################### Install wp-cli ###########################'
echo '##################################################################'

#/opt/puppetlabs/bin/puppet apply site.pp  || exit 1

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar || exit 1

chmod +x wp-cli.phar || exit 1
mv wp-cli.phar /usr/local/bin/wp || exit 1
echo "PATH=$PATH:/usr/local/bin" >> ~/.bashrc || exit 1
PATH=$PATH:/usr/local/bin
export PATH

chown -R apache:apache /var/www/html/ || exit 1

su -s /bin/bash apache -c 'wp --info' || exit 1

wp cli update || exit 1

# wp package install wp-cli/restful  || exit 1

su -s /bin/bash apache -c 'wp core download --path=/var/www/html' || exit 1


su -s /bin/bash apache -c "wp core config --path=/var/www/html --dbname=${wp_db_name} --dbuser=${db_username} --dbpass=${db_password} --extra-php <<PHP
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', true);
define('WP_MEMORY_LIMIT', '256M');
PHP"




su -s /bin/bash apache -c "wp core install --path=/var/www/html --url=\"${url}\" --title=Codingbee --admin_user=${wp_web_admin_username} --admin_password=${wp_web_admin_user_password} --admin_email=YOU@YOURDOMAIN.com"

# note, a random password is generated for the new user.
su -s /bin/bash apache -c "wp user create guestadmin guestadmin@example.com --role=administrator --path=/var/www/html"


su -s /bin/bash apache -c "wp option update blogdescription \"$slogan\" --path=/var/www/html/"



su -s /bin/bash apache -c 'wp plugin delete hello --path=/var/www/html/'  # removing default plugin
su -s /bin/bash apache -c 'wp plugin delete akismet --path=/var/www/html/'      # removing default plugin

su -s /bin/bash apache -c 'wp plugin install coming-soon --activate --path=/var/www/html/'
su -s /bin/bash apache -c '# wp plugin install custom-admin-bar --activate --path=/var/www/html/'  # broken - try installing manually.
# wp plugin install 'contact-form-7' --activate --path='/var/www/html/'     # gives a warning message, try installing manually.
su -s /bin/bash apache -c 'wp plugin install custom-menu-wizard --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install disable-comments --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install display-widgets --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install duplicate-post --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install google-analytics-for-wordpress --activate --path=/var/www/html/'
# wp plugin install 'save-grab' --activate --path='/var/www/html/'           # broken - try installing manually.
su -s /bin/bash apache -c 'wp plugin install olevmedia-shortcodes --activate --path=/var/www/html/'
# su -s /bin/bash apache -c 'wp plugin install image-elevator --activate --path=/var/www/html/'         # not best practice to use this. will end up making backups too big.
su -s /bin/bash apache -c 'wp plugin install post-content-shortcodes --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install post-editor-buttons-fork --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install publish-view --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install recently-edited-content-widget --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install rel-nofollow-checkbox --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install search-filter --activate --path=/var/www/html/'
# su -s /bin/bash apache -c 'wp plugin install simple-custom-css --activate --path=/var/www/html/'  # this feature comes natively as part of wordpress 4.7
su -s /bin/bash apache -c 'wp plugin install syntaxhighlighter --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install table-of-contents-plus --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install tablepress --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install wp-github-gist --activate --path=/var/www/html/'
#su -s /bin/bash apache -c 'wp plugin install wordpress-importer --activate --path=/var/www/html/'

mkdir /root/downloads  || exit 1
cd /root/downloads || exit 1
curl -L ${dropbox_folder_link} > /root/downloads/download.zip || exit 1
unzip download.zip -x / || exit 1
rm download.zip || exit 1

chown -R apache:apache /root/downloads

mv /root/downloads/premium-plugins /var/www/html
cd /var/www/html/premium-plugins
su -s /bin/bash apache -c 'wp plugin install ./backupbuddy/backupbuddy.zip --activate --path=/var/www/html/'

su -s /bin/bash apache -c 'wp plugin install ./wp-all-export-pro.zip --activate --path=/var/www/html/'

su -s /bin/bash apache -c 'wp plugin install ./wp-all-import-pro.zip --activate --path=/var/www/html/'
#rm -rf /root/downloads/premium-plugins


mv /root/downloads/premium-themes /var/www/html
cd /var/www/html/premium-themes
su -s /bin/bash apache -c 'wp theme install ./customizr-pro.zip --activate --path=/var/www/html/'
rm -rf /var/www/html/premium-themes



for line in `cat /root/downloads/categories.csv` ; do

  echo $line
  name=`echo $line | cut -d',' -f1`
  slug=`echo $line | cut -d',' -f2`
  parent=`echo $line | cut -d',' -f3`
  echo "The name is ${name}"
  echo "The slug is ${slug}"
  echo "The parent is ${parent}"

  parent_id=`wp term list category --fields=name,term_id --path=/var/www/html/ | grep ${parent} | awk '{print $4;}'`

  echo "The parent_id is ${parent_id}"
  wp term create category ${name} --slug=${slug} --parent=${parent_id} --path=/var/www/html/
done






su -s /bin/bash apache -c "wp rewrite structure '/%category%/%postname%' --path=/var/www/html/"

echo 'php_value suhosin.post.max_vars 5000
php_value suhosin.request.max_vars 5000
php_value memory_limit 256M
php_value max_execution_time 600
php_value upload_max_filesize 70M
php_value post_max_size 128M
php_value upload_tmp_dir 70M
php_value max_input_vars 5000


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


#yum install -y rubygems
#yum install -y ruby-devel
#yum install -y gcc
#yum install -y zlib-devel
#gem install nokogiri -v 1.6.8.1


cp /root/downloads/wp-all-import-exports/codingbee-posts-exports.zip /var/www/html/



echo '127.0.0.1  codingbee.net' >> /etc/hosts

# http://elementalselenium.com/tips/38-headless
yum -y install rubygems ruby-devel
yum -y groupinstall 'Development Tools'
yum -y install Xvfb firefox

cd /root
# gem install headless   # using phantomjs instead of this
gem install selenium-webdriver

#wget https://github.com/mozilla/geckodriver/releases/download/v0.14.0/geckodriver-v0.14.0-linux64.tar.gz    # this is headless gem dependency
#tar -xvzf geckodriver-v0.14.0-linux64.tar.gz   # this is a headless gem dependency
#cp geckodriver /usr/bin    # this is a headless gem dependency

wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
tar -xjvf phantomjs-2.1.1-linux-x86_64.tar.bz2
cp ./phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin

phantomjs --webdriver=2816 1>/dev/null &
ruby /root/wordpress-codingbee/scripts/dummy.rb
ruby /root/wordpress-codingbee/scripts/import_all_impex_plugin_templates.rb
ruby /root/wordpress-codingbee/scripts/import_posts.rb

pkill phantomjs

# rm /var/www/html/codingbee-posts-exports.zip
# rm /var/www/html/codingbee-pages-exports.zip
