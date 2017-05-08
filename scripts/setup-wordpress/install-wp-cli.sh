#!/bin/bash

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
