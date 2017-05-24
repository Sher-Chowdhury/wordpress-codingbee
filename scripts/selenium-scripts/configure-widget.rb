#!/usr/bin/env ruby

# you can run this script (from the irb command line) by doing the following
# source("configure-widget.rb")


menu_name = ARGV[0]
wp_web_admin_username = ARGV[1]
wp_web_admin_user_password = ARGV[2]
puts "The wordpress menu name is: #{menu_name}"
puts "The wordpress frontend admin username: #{wp_web_admin_username}"
puts "The wordpress frontend admin password: #{wp_web_admin_user_password}"
dropdown_menu_html_id = ARGV[3]
category_html_id = ARGV[4]
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
sleep(2)
driver.find_element(:id, "wp-submit").click
sleep(2)
driver.navigate.to "http://codingbee.net/wp-admin/widgets.php"
widget_header = driver.find_element(:id, 'left').find_element(:xpath, ".//*[contains(., '#{menu_name}')]")
widget_header.click


sleep(2)

# the following works:
dropdown_list = driver.find_element(:class, 'nav-menu-widget-form-controls').find_element(:xpath, "//select[starts-with(@id, 'widget-#{dropdown_menu_html_id}-nav_menu')]")

sleep(2)

#dropdown_list = Selenium::WebDriver::Support::Select.new(select_menu_dropdown)
#option_list.select_by(:text, 'rhcsa')

# had to take this convolated appraoch to select this dropdown list item.
options_list =  dropdown_list.find_elements(:tag_name, "option")
options_list.each do |option|
  puts option.text
  if option.text == 'rhcsa'
     option.click
  end
end

exit

# driver.quit

