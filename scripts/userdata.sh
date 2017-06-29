#!/bin/bash

#curl -s https://raw.githubusercontent.com/Sher-Chowdhury/wordpress-codingbee/master/scripts/userdata.sh -o ~/userdata.sh
#chmod u+x ~/userdata.sh
#~/userdata.sh                                      \
#--url codingbee.net                                \
#--wp_db_name xxxx                                 \
#--db_username xxxxxx                                \
#--db_password xxxxxxxxx                          \
#--wp_web_admin_username xxxxxxxxx                       \
#--wp_web_admin_user_password xxxxxxxx              \
#--wp_web_guest_admin_user_password xxxxxxx        \
#--slogan xxxxxxxxx                               \
#--ssh_guestadmin_username xxxxxxxxxx               \
#--ssh_guestadmin_password xxxxxxxxxx                  \
#--backupbuddy_username xxxxxxxxxx                   \
#--backupbuddy_password xxxxxxxxxx                \
#--premium_theme_licence_key xxxxxxxxxxxxx                \
#--dropbox_folder_link https://www.dropbox.com/sh/qgqz82xlkq4dhfj/AADJv_s5GdXJYAv4xar5ofaFa?dl=1              \
#--follow_up_userdata userdata-freshbuild.sh         # should equal to either:
                                                      # userdata-backupbuddy.sh
                                                      # userdata-freshbuild.sh




echo '##################################################################'
echo '####### About to run scripts/userdata.sh #########################'
echo '##################################################################'

if [ $# -ne 30 ]; then
  echo "ECHO: line ${LINENO}: Incorrect number of parameters specified. $# specified, but 15 parameters required"
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
    --ssh_guestadmin_username)
      ssh_guestadmin_username=${2}
      ;;
    --ssh_guestadmin_password)
      ssh_guestadmin_password=${2}
      ;;
    --backupbuddy_username)
      backupbuddy_username=${2}
      ;;
    --backupbuddy_password)
      backupbuddy_password=${2}
      ;;
    --premium_theme_licence_key)
      premium_theme_licence_key=${2}
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
#yum install -y MariaDB-server mariadb-devel mariadb-libs gcc rubygems ruby-devel
#gem install mysql2
#yum remove -y MariaDB-server mariadb-devel mariadb-libs gcc rubygems ruby-devel

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

. ~/wordpress-codingbee/scripts/base/setup-vanilla-lamp.sh
. ~/wordpress-codingbee/scripts/base/create-new-db-for-wordpress.sh
. ~/wordpress-codingbee/scripts/base/optimize-php-for-wordpress.sh
. ~/wordpress-codingbee/scripts/base/create_guest_admin_login_account.sh


. ~/wordpress-codingbee/scripts/${follow_up_userdata}



# here's a guide on how to access a droplet's metadata and userdata:
# https://www.digitalocean.com/community/tutorials/an-introduction-to-droplet-metadata
# e.g. the following will pull down the userdata:
curl http://169.254.169.254/metadata/v1/user-data
