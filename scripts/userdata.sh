#!/bin/bash

echo '##################################################################'
echo '####### About to run scripts/userdata.sh #########################'
echo '##################################################################'


yum install git -y || exit 1

echo 'Host *' > ~/.ssh/config || exit 1
echo '  StrictHostKeyChecking no' >> ~/.ssh/config || exit 1


git clone https://github.com/Sher-Chowdhury/wordpress-codingbee.git || exit 1


rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm || exit 1
yum install -y puppet-agent || exit 1


echo "PATH=$PATH:/opt/puppetlabs/bin" >> /root/.bashrc || exit 1
PATH=$PATH:/opt/puppetlabs/bin || exit 1


# restarting bash session
# http://unix.stackexchange.com/questions/22721/completely-restart-bash
exec bash -l || exit 1

puppet module install puppetlabs-wordpress_app --version 0.2.0 || exit 1



