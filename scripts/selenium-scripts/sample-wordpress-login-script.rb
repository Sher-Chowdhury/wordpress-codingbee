#!/usr/bin/env ruby

# pre-reqs
# need to make sure you have the following installed:
# - selenium ruby gem
# - geckodriver executable binary - https://github.com/mozilla/geckodriver/releases


# you can run this script by doing the following
# load './selenium.rb'
require 'selenium-webdriver'
driver = Selenium::WebDriver.for :firefox
driver.navigate.to "http://codingbee.net/wp-login.php"
user_login_element = driver.find_element(:id, 'user_login')
user_login_element.send_keys "sher"
user_password_element = driver.find_element(:id, 'user_pass')
user_password_element.send_keys "password"
driver.find_element(:id, "wp-submit").click
driver.navigate.to "http://codingbee.net/wp-admin/widgets.php"
# driver.quit
