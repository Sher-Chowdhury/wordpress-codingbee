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
