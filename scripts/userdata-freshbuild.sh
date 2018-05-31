#!/usr/bin/env bash
set -ex

DATE=$(date +"%d-%m-%Y-%H_%M_%S")
# http://stackoverflow.com/questions/3173131/redirect-copy-of-stdout-to-log-file-from-within-bash-script-itself
exec > >(tee -i /tmp/log-wp-${DATE}.txt)
date
echo "Info: This log was generated by running a script"

mkdir -p /var/log/userdata/freshbuild/

. ~/wordpress-codingbee/scripts/setup-wordpress/install-wp-cli.sh                     > /var/log/userdata/freshbuild/wp-cli.log
. ~/wordpress-codingbee/scripts/setup-wordpress/install-and-configure-wordpress.sh    > /var/log/userdata/freshbuild/install-and-configure-wordpress.log
. ~/wordpress-codingbee/scripts/setup-wordpress/create-wordpress-users.sh             > /var/log/userdata/freshbuild/create-wordpress-users.log
. ~/wordpress-codingbee/scripts/setup-wordpress/install-free-wordpress-plugins.sh     > /var/log/userdata/freshbuild/install-free-wordpress-plugins.log
. ~/wordpress-codingbee/scripts/setup-wordpress/install-premium-wordpress-plugins.sh  > /var/log/userdata/freshbuild/install-premium-wordpress-plugins.log
. ~/wordpress-codingbee/scripts/setup-wordpress/install-premium-wordpress-themes.sh   > /var/log/userdata/freshbuild/install-premium-wordpress-themes.log
. ~/wordpress-codingbee/scripts/setup-wordpress/create-wordpress-categories.sh        > /var/log/userdata/freshbuild/create-wordpress-categories.log
. ~/wordpress-codingbee/scripts/setup-wordpress/install-selenium.sh                   > /var/log/userdata/freshbuild/install-selenium.log
. ~/wordpress-codingbee/scripts/setup-wordpress/imports-posts.sh                      > /var/log/userdata/freshbuild/imports-posts.log
. ~/wordpress-codingbee/scripts/setup-wordpress/install-xfvb-for-selenium.sh          > /var/log/userdata/freshbuild/install-xfvb-for-selenium.log
. ~/wordpress-codingbee/scripts/setup-wordpress/create-custom-menus.sh                > /var/log/userdata/freshbuild/create-custom-menus.log
. ~/wordpress-codingbee/scripts/setup-wordpress/import-tablepress-files.sh            > /var/log/userdata/freshbuild/import-tablepress-files.log
. ~/wordpress-codingbee/scripts/setup-wordpress/setup-backupbuddy.sh                  > /var/log/userdata/freshbuild/setup-backupbuddy.log
. ~/wordpress-codingbee/scripts/setup-wordpress/setup-premium-theme.sh                > /var/log/userdata/freshbuild/setup-premium-theme.log
