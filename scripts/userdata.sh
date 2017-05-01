#!/bin/bash

# curl -s https://raw.githubusercontent.com/Sher-Chowdhury/wordpress-codingbee/master/scripts/userdata.sh -o ~/userdata.sh
# chmod u+x ~/userdata.sh
# ~/userdata.sh                           \
# --url codingbee.net                     \
# --wp_db_name xxxx                       \
# --db_username xxxx                      \
# --db_password xxxx                      \
# --wp_web_admin_username xxxx            \
# --wp_web_admin_user_password xxxx       \
# --wp_web_guest_admin_user_password xxxx \
# --slogan xxxx                           \
# --dropbox_folder_link xxxx              \
# --follow_up_userdata xxxx         # should equal to either:
                                    # userdata-backupbuddy.sh
                                    # userdata-freshbuild.sh

echo '##################################################################'
echo '####### About to run scripts/userdata.sh #########################'
echo '##################################################################'

if [ $# -ne 20 ]; then
  echo "ECHO: line ${LINENO}: Incorrect number of parameters specified. $# specified, but 10 parameters required"
  exit 1
fi

while [ $# -gt 0 ]; do
  echo "about to process ${1} and ${2}"
  if [[ ! ${1} =~ ^-- ]]; then
    echo "ERROR: line ${LINENO}: The parameter '${1}' is not a parameter option"
    exit 1
  fi

  if [[ ${2} =~ ^-- ]]; then
    echo "ERROR: line ${LINENO}: The parameter '${2}' is not a parameter option"
    exit 1
  fi

  case "$1" in
    --url)
      url=${2}
      ;;
    --wp_db_name)
      wp_db_name=${2}
      ;;
    --db_username)
      db_username=${2}
      ;;
    --db_password)
      db_password=${2}
      ;;
    --wp_web_admin_username)
      wp_web_admin_username=${2}
      ;;
    --wp_web_admin_user_password)
      wp_web_admin_user_password=${2}
      ;;
    --slogan)
      slogan=${2}
      ;;
    --dropbox_folder_link)
      dropbox_folder_link=${2}
      ;;
    --wp_web_guest_admin_user_password)
      wp_web_guest_admin_user_password=${2}
      ;;
    --follow_up_userdata)
      follow_up_userdata=${2}
      ;;
    *)
      echo "ERROR: The parameter ${1} is not a valid parameter option"
      exit 1
      ;;
  esac

  echo "INFO: line ${LINENO}: The value for ${1} is ${2}"

  shift
  shift
done

# the following is a workaround to get mysql2 gem to install successfully, because mysql2 doesn't install with the latest mariadb rpms from mariadb repo.
yum install -y MariaDB-server mariadb-devel mariadb-libs gcc rubygems ruby-devel
gem install mysql2

# https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-on-centos-7

yum install -y git          || { echo "ERROR: failed to install git"; exit 1; }
yum install -y epel-release || { echo "ERROR: failed to install epel-release"; exit 1; }
yum install -y vim          || { echo "ERROR: failed to install vim"; exit 1; }
yum install -y wget         || { echo "ERROR: failed to install wget"; exit 1; }
yum install -y augeas       || { echo "ERROR: failed to install augeas"; exit 1; }
yum install -y zip          || { echo "ERROR: failed to install zip"; exit 1; }
yum install -y unzip        || { echo "ERROR: failed to install unzip"; exit 1; }
#yum install -y php-gd      || { echo "ERROR: failed to install php-gd"; exit 1; }

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

echo "db_username is ${db_username}"
echo "db_password is ${db_password}"

# note: you can user curly brackets here.
mysql -u root -e "CREATE USER '$db_username'@'localhost' IDENTIFIED BY '$db_password';" || exit 1
mysql --user='root' -e 'select host, user, password from mysql.user;'

# another approach that should work
#query="CREATE USER '${db_username}'@'localhost' IDENTIFIED BY '${db_password}';"
#echo $query > /tmp/createuser.sql
#mysql --user='root' < /tmp/createuser.sql
#mysql --user='root' -e 'select host, user, password from mysql.user;'

# This creates new db
mysql -u root -e "CREATE DATABASE $wp_db_name" || { echo "ERROR: line ${LINENO}: failed to create DB"; exit 1; }

# grant full priveleges of db user to wordpress db:
echo "About to grant priveleges"
mysql -u root -e "GRANT ALL PRIVILEGES ON $wp_db_name.* TO '$db_username'@'localhost' IDENTIFIED BY '$db_password';" || exit 1

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


. ~/wordpress-codingbee/scripts/${follow_up_userdata}



# here's a guide on how to access a droplet's metadata and userdata:
# https://www.digitalocean.com/community/tutorials/an-introduction-to-droplet-metadata
# e.g. the following will pull down the userdata:
curl http://169.254.169.254/metadata/v1/user-data
