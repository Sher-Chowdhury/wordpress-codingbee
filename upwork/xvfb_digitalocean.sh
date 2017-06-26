#! /bin/bash
## Script for installing dependencies for headless selenium browsing on Digitalocean CentOS droplet
## 2017 June 26

## solution for problem with [Errno 12] Cannot allocate memory during yum install
## https://superuser.com/a/1101864/476445
## Creating swap file
fallocate -l 512M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
## Remove swap file (if needed)
#swapoff -a
#rm -f /swapfile


## updating /etc/hosts
echo '46.101.19.11  codingbee.net' >> /etc/hosts
echo '127.0.0.1  codingbee.net' >> /etc/hosts

## instalation of Xvfb dependencies
## https://gist.github.com/textarcana/5855427
sudo yum -y install firefox Xvfb libXfont Xorg
## Other steps from gist are not needed


## python3.6 installation
## https://www.digitalocean.com/community/tutorials/how-to-install-python-3-and-set-up-a-local-programming-environment-on-centos-7
sudo yum -y update
sudo yum -y install yum-utils
yum -y groupinstall 'Development Tools'
sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm
sudo yum -y install python36u
## is python3.6 installed check
#python3.6 -V
sudo yum -y install python36u-pip
sudo yum -y install python36u-devel

## installing python3.6 modules via pip3
sudo pip3.6 install selenium


## installing geckodriver
## grab from here newest linux64.tar.gz archive https://github.com/mozilla/geckodriver/releases
wget https://github.com/mozilla/geckodriver/releases/download/v0.17.0/geckodriver-v0.17.0-linux64.tar.gz
tar -xvzf geckodriver-v0.17.0-linux64.tar.gz
cp geckodriver /usr/bin
## Don't forget to connect geckodriver executable in python program that is variable geckodriverexecutablePath


## How to start python3.6 program nogui
##xvfb-run python3.6 programname.py parameters



