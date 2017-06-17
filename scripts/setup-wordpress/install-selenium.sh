#!/bin/bash

#yum install -y rubygems
#yum install -y ruby-devel
#yum install -y gcc
#yum install -y zlib-devel
#gem install nokogiri -v 1.6.8.1

echo '127.0.0.1  codingbee.net' >> /etc/hosts

# http://elementalselenium.com/tips/38-headless
yum -y install rubygems ruby-devel
yum -y groupinstall 'Development Tools'
yum -y install Xvfb firefox

cd /root
# gem install headless   # using phantomjs instead of this
gem install selenium-webdriver -v 3.4.0

#wget https://github.com/mozilla/geckodriver/releases/download/v0.14.0/geckodriver-v0.14.0-linux64.tar.gz    # this is headless gem dependency
#tar -xvzf geckodriver-v0.14.0-linux64.tar.gz   # this is a headless gem dependency
#cp geckodriver /usr/bin    # this is a headless gem dependency

wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
tar -xjvf phantomjs-2.1.1-linux-x86_64.tar.bz2
cp ./phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin
