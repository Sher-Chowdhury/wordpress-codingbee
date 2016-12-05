#!/bin/bash

echo '##################################################################'
echo '####### About to run scripts/userdata.sh #########################'
echo '##################################################################'


yum install git -y || exit 1
yum install epel-release -y || exit 1
yum install vim -y || exit 1


echo -e "\n\n\n" | ssh-keygen -P ""
echo 'Host *' > ~/.ssh/config || exit 1
echo '  StrictHostKeyChecking no' >> ~/.ssh/config || exit 1

cd ~
git clone https://github.com/Sher-Chowdhury/wordpress-codingbee.git || exit 1


rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm || exit 1
yum install -y puppet-agent || exit 1


echo "PATH=$PATH:/opt/puppetlabs/bin" >> /root/.bashrc || exit 1
PATH=$PATH:/opt/puppetlabs/bin || exit 1


# restarting bash session
# http://unix.stackexchange.com/questions/22721/completely-restart-bash
exec bash -l || exit 1

puppet module install hunner-wordpress --version 1.0.0 || exit 1

cd ~/wordpress-codingbee

puppet apply site.pp

