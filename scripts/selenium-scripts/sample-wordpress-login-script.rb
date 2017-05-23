#!/usr/bin/env ruby


# pre-reqs
# need to make sure you have the following installed:
# - selenium ruby gem
# - geckodriver executable binary - https://github.com/mozilla/geckodriver/releases


# you can run this script (via the irb command line) by doing the following
# source("sample-wordpress-login-script.rb")
# https://stackoverflow.com/questions/13112245/ruby-how-to-load-a-file-into-interactive-ruby-console-irb

 
require 'selenium-webdriver'
driver = Selenium::WebDriver.for :firefox
driver.navigate.to "http://codingbee.net/wp-login.php"
user_login_element = driver.find_element(:id, 'user_login')
user_login_element.send_keys "sher"
user_password_element = driver.find_element(:id, 'user_pass')
user_password_element.send_keys "password"
sleep(5)
driver.find_element(:id, "wp-submit").click
sleep(5)
driver.navigate.to "http://codingbee.net/wp-admin/widgets.php"
# driver.quit
