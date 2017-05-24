#!/usr/bin/env ruby

# you can run this script (from the irb command line) by doing the following
# source("configure-widget.rb")


=begin
menu_name = ARGV[0]
wp_web_admin_username = ARGV[1]
wp_web_admin_user_password = ARGV[2]
puts "The wordpress frontend admin username: #{wp_web_admin_username}"
puts "The wordpress frontend admin password: #{wp_web_admin_user_password}"
dropdown_menu_html_id = ARGV[3]
category_html_id = ARGV[4]
puts "The dropdown_menu_html_id: #{dropdown_menu_html_id}"
puts "The category_html_id: #{category_html_id}"
=end


menu_name = rhcsa 
wp_web_admin_username = 'sher'
wp_web_admin_user_password = 'password'
puts "The wordpress frontend admin username: #{wp_web_admin_username}"
puts "The wordpress frontend admin password: #{wp_web_admin_user_password}"
dropdown_menu_html_id = 'nav_menu-1' 
category_html_id = '20'
puts "The dropdown_menu_html_id: #{dropdown_menu_html_id}"
puts "The category_html_id: #{category_html_id}"
############################################################################
######################## Start Firefox session #############################
############################################################################

 
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

=begin


sleep(2)

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

=end
