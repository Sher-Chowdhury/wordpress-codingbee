#!/usr/bin/env bash
set -ex

echo '##################################################################'
echo '################ Create new MySLQ user account ###################'
echo '##################################################################'


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

echo '##################################################################'
echo '############## Create new DB for Wordpress to use ################'
echo '##################################################################'



# This creates new db
mysql -u root -e "CREATE DATABASE $wp_db_name CHARACTER SET utf8 COLLATE utf8_general_ci" || { echo "ERROR: failed to create DB"; exit 1; }

# The following will list out all the databases along with they're encoding and collation settings
mysql -u root -e "SELECT SCHEMA_NAME 'database', default_character_set_name 'charset', DEFAULT_COLLATION_NAME 'collation' FROM information_schema.SCHEMATA;"


echo '##################################################################'
echo '###### Give new db user account full priveleges to new DB ########'
echo '##################################################################'


# grant full priveleges of db user to wordpress db:
echo "About to grant priveleges"
mysql -u root -e "GRANT ALL PRIVILEGES ON $wp_db_name.* TO '$db_username'@'localhost' IDENTIFIED BY '$db_password';" || exit 1

mysql -u root -e "FLUSH PRIVILEGES;" || exit 1
