#!/bin/bash

echo '##################################################################'
echo '####### About to run scripts/userdata.sh #########################'
echo '##################################################################'


yum install git -y || exit 1
yum install epel-release -y || exit 1
yum install vim -y || exit 1
yum install wget -y || exit 1


echo -e "\n\n\n" | ssh-keygen -P ""
echo 'Host *' > ~/.ssh/config || exit 1
echo '  StrictHostKeyChecking no' >> ~/.ssh/config || exit 1

cd ~
git clone https://github.com/Sher-Chowdhury/wordpress-codingbee.git || exit 1


rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm || exit 1
yum install -y puppet-agent || exit 1


echo "PATH=$PATH:/opt/puppetlabs/bin" >> /root/.bashrc || exit 1
PATH=$PATH:/opt/puppetlabs/bin || exit 1


/opt/puppetlabs/bin/puppet module install hunner-wordpress --version 1.0.0 || exit 1
/opt/puppetlabs/bin/puppet module install mayflower-php --version 4.0.0-beta1



cd ~/wordpress-codingbee || exit 1

/opt/puppetlabs/bin/puppet apply site.pp  || exit 1

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar || exit 1

php wp-cli.phar --info || exit 1

chmod +x wp-cli.phar || exit 1
mv wp-cli.phar /usr/local/bin/wp || exit 1
echo "PATH=$PATH:/usr/local/bin" >> ~/.bashrc || exit 1
PATH=$PATH:/usr/local/bin
export PATH


wp --info

wp cli update || exit 1


wp core download --path=/var/www/html


wp core config --path=/var/www/html --dbname=wordpress_db --dbuser=wordpress --dbpass=password123 --extra-php <<PHP
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', true);
define('WP_MEMORY_LIMIT', '256M');
PHP




wp core install --path=/var/www/html --url=codingbee.net --title=Codingbee --admin_user=admin --admin_password=password --admin_email=YOU@YOURDOMAIN.com


chown -R apache:apache /var/www/html/


wp plugin delete hello-dolly  # removing default plugin
wp plugin delete akismet      # removing default plugin

wp plugin install 'coming-soon' --activate --path='/var/www/html/'
# wp plugin install 'custom-admin-bar' --activate --path='/var/www/html/'   # broken - try installing manually. 
# wp plugin install 'contact-form-7' --activate --path='/var/www/html/'     # gives a warning message, try installing manually. 
wp plugin install 'custom-menu-wizard' --activate --path='/var/www/html/'
wp plugin install 'disable-comments' --activate --path='/var/www/html/'
wp plugin install 'display-widgets' --activate --path='/var/www/html/'
wp plugin install 'duplicate-post' --activate --path='/var/www/html/'
wp plugin install 'google-analytics-for-wordpress' --activate --path='/var/www/html/'
# wp plugin install 'save-grab' --activate --path='/var/www/html/'           # broken - try installing manually.
wp plugin install 'olevmedia-shortcodes' --activate --path='/var/www/html/'
wp plugin install 'image-elevator' --activate --path='/var/www/html/'
wp plugin install 'post-content-shortcodes' --activate --path='/var/www/html/'
wp plugin install 'post-editor-buttons-fork' --activate --path='/var/www/html/'
wp plugin install 'publish-view' --activate --path='/var/www/html/'
wp plugin install 'recently-edited-content-widget' --activate --path='/var/www/html/'
wp plugin install 'rel-nofollow-checkbox' --activate --path='/var/www/html/'
wp plugin install 'search-filter' --activate --path='/var/www/html/'
wp plugin install 'simple-custom-css' --activate --path='/var/www/html/'
wp plugin install 'syntaxhighlighter' --activate --path='/var/www/html/'
wp plugin install 'table-of-contents-plus' --activate --path='/var/www/html/'
wp plugin install 'tablepress' --activate --path='/var/www/html/'
wp plugin install 'wp-github-gist' --activate --path='/var/www/html/'
wp plugin install 'wedocs' --activate --path='/var/www/html/'
wp plugin install https://www.dropbox.com/s/y6ojfpy802gsaq6/backupbuddy-7.2.1.1.zip?dl=1 --activate --path='/var/www/html/'

wp theme install https://github.com/tareq1988/wedocs/archive/develop.zip --activate --path='/var/www/html/'

chown -R apache:apache /var/www/html/


