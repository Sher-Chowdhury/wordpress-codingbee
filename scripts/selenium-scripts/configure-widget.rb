#!/usr/bin/env ruby

# you can run this script (from the irb command line) by doing the following
# source("configure-widget.rb")

 
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
widget_header = driver.find_element(:id, 'left').find_element(:xpath, './/*[contains(., "RHCSA")]')
widget_header.click


sleep(2)
select_menu_dropdown = driver.find_element(:class, 'nav-menu-widget-form-controls').find_element(:xpath, '//select[starts-with(@id, "widget-nav_menu")]')

# the following works:
driver.find_element(:class, 'nav-menu-widget-form-controls').find_element(:xpath, "//select[starts-with(@id, 'widget-nav_menu-1-nav_menu')]").click

sleep(2)
options_list = select_menu_dropdown.find_elements(:tag_name=>"option")

options_list.each do |option|
  puts option.text
  puts option.text
  puts option.text
  puts option.text
  puts option.text
  if option.text == 'rhcsa'
     option.click
  end
end


# driver.quit
