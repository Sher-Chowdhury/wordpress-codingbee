#!/usr/bin/env bash
set -ex

cd ~/wordpress-codingbee || exit 1

echo '##################################################################'
echo '######################### Install apache #########################'
echo '##################################################################'
yum install -y httpd  || exit 1
systemctl enable httpd || exit 1
systemctl start httpd  || exit 1


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
sed -i 's/^post_max_size.*/post_max_size = 200M/g' /etc/php.ini
sed -i 's/^max_execution_time.*/max_execution_time = 300/g' /etc/php.ini
systemctl restart httpd || exit 1


# needed to apply the following otherwise unable to bulk delete lots of posts
echo "LimitRequestLine 81900" >> /etc/httpd/conf/httpd.conf || exit 1
systemctl restart httpd  || exit 1

# The following is needed for our custom permalink structure to work.
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
systemctl restart httpd || exit 1
