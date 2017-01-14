#!/bin/bash

# curl https://raw.githubusercontent.com/Sher-Chowdhury/wordpress-codingbee/master/scripts/userdata.sh -o ~/userdata.sh -s
# chmod u+x ~/userdata.sh
# ~/userdata.sh codingbee.net

# 1. url
# 2. wordpress db name
# 3. db username
# 4. db user password
# 5. wp admin username
# 6. wp admin user's password
# 7. slogan
#
#
#
#



echo '##################################################################'
echo '####### About to run scripts/userdata.sh #########################'
echo '##################################################################'

# https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-on-centos-7

yum install -y git          || exit 1
yum install -y epel-release || exit 1
yum install -y vim          || exit 1
yum install -y wget         || exit 1
yum install -y augeas       || exit 1
#yum install -y php-gd      || exit 1

echo -e "\n\n\n" | ssh-keygen -P ""
echo 'Host *' > ~/.ssh/config || exit 1
echo '  StrictHostKeyChecking no' >> ~/.ssh/config || exit 1

cd ~
git clone https://github.com/Sher-Chowdhury/wordpress-codingbee.git || exit 1


#rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm || exit 1
#yum install -y puppet-agent || exit 1


#echo "PATH=$PATH:/opt/puppetlabs/bin" >> /root/.bashrc || exit 1
#PATH=$PATH:/opt/puppetlabs/bin || exit 1


#/opt/puppetlabs/bin/puppet module install hunner-wordpress --version 1.0.0 || exit 1
#/opt/puppetlabs/bin/puppet module install mayflower-php --version 4.0.0-beta1



cd ~/wordpress-codingbee || exit 1

echo '##################################################################'
echo '######################### Install apache #########################'
echo '##################################################################'
yum install -y httpd  || exit 1
systemctl enable httpd || exit 1
systemctl start httpd  || exit 1

# needed to apply the following otherwise unable to bulk delete lots of posts 
echo "LimitRequestLine 81900" >> /etc/httpd/conf/httpd.conf || exit 1
systemctl restart httpd  || exit 1

echo '##################################################################'
echo '##################### Install mariadb ############################'
echo '##################################################################'

# https://downloads.mariadb.org/mariadb/repositories/#mirror=exascale&distro=CentOS&distro_release=centos7-amd64--centos7&version=10.1


cat > /etc/yum.repos.d/mariadb.repo  <<- EOM
# MariaDB 10.1 CentOS repository list - created 2017-01-07 15:53 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOM

yum install -y MariaDB-server || exit 1

systemctl enable mariadb || exit 1
systemctl start mariadb || exit 1

# https://www.digitalocean.com/community/tutorials/how-to-create-a-new-user-and-grant-permissions-in-mysql

# This creates new db user account
mysql -u root -e "CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'password123';" || exit 1

# This creates new db
mysql -u root -e "CREATE DATABASE wordpress_db" || exit 1

# grant full priveleges of db user to wordpress db:
mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress_db.* TO wordpress@localhost IDENTIFIED BY 'password123';" || exit 1

mysql -u root -e "FLUSH PRIVILEGES;" || exit 1


echo '##################################################################'
echo '####################### Install php 7 ############################'
echo '##################################################################'
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm || exit 1
yum -y install php70w || exit 1

yum install -y php70w-mysqlnd || exit 1
yum install -y php70w-xml

systemctl restart httpd || exit 1

# check that the correct version is installed:

php -v || exit 1

echo '<?php phpinfo(); ?>' > /var/www/html/php-info.php

chown apache:apache /var/www/html/php-info.php

php --ini

sed -i 's/^memory_limit.*/memory_limit = 512M/g' /etc/php.ini
sed -i 's/^upload_max_filesize.*/upload_max_filesize = 100M/g' /etc/php.ini
sed -i 's/^post_max_size.*/post_max_size = 100M/g' /etc/php.ini
sed -i 's/^max_execution_time.*/max_execution_time = 300/g' /etc/php.ini
systemctl restart httpd

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


su -s /bin/bash apache -c 'wp core download --path=/var/www/html' || exit 1


su -s /bin/bash apache -c "wp core config --path=/var/www/html --dbname=wordpress_db --dbuser=wordpress --dbpass=password123 --extra-php <<PHP
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', true);
define('WP_MEMORY_LIMIT', '256M');
PHP"




su -s /bin/bash apache -c "wp core install --path=/var/www/html --url=\"${1}\" --title=Codingbee --admin_user=admin --admin_password=password --admin_email=YOU@YOURDOMAIN.comi"

su -s /bin/bash apache -c 'wp option update blogdescription "Infrastructure as Code is the future" --path=/var/www/html/'



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
su -s /bin/bash apache -c 'wp plugin install wordpress-importer --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install https://www.dropbox.com/s/y6ojfpy802gsaq6/backupbuddy-7.2.1.1.zip?dl=1 --activate --path=/var/www/html/'


#su -s /bin/bash apache -c 'wp theme install https://github.com/tareq1988/wedocs/archive/develop.zip --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp theme install customizr --activate --path=/var/www/html/'


rm -f categories.csv
wget https://www.dropbox.com/s/yfc5uqq1x0iuqqx/categories.csv

for line in `cat categories.csv` ; do

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


augtool <<-EOF
ls /files/etc/httpd/conf/httpd.conf/Directory[arg='\"/var/www/html\"']/*[self::directive='AllowOverride']
print /files/etc/httpd/conf/httpd.conf/Directory[arg='\"/var/www/html\"']/*[self::directive='AllowOverride']
get /files/etc/httpd/conf/httpd.conf/Directory[arg='\"/var/www/html\"']/*[self::directive='AllowOverride']/arg
set /files/etc/httpd/conf/httpd.conf/Directory[arg='\"/var/www/html\"']/*[self::directive='AllowOverride']/arg ALL
ls /files/etc/httpd/conf/httpd.conf/Directory[arg='\"/var/www/html\"']/*[self::directive='AllowOverride']
print /files/etc/httpd/conf/httpd.conf/Directory[arg='\"/var/www/html\"']/*[self::directive='AllowOverride']
get /files/etc/httpd/conf/httpd.conf/Directory[arg='\"/var/www/html\"']/*[self::directive='AllowOverride']/arg
save
quit
EOF
systemctl restart httpd


su -s /bin/bash apache -c "wp rewrite structure '/%category%/%postname%' --path=/var/www/html/"

# here's a guide on how to access a droplet's metadata and userdata:
# https://www.digitalocean.com/community/tutorials/an-introduction-to-droplet-metadata
# e.g. the following will pull down the userdata:
curl http://169.254.169.254/metadata/v1/user-data
 



