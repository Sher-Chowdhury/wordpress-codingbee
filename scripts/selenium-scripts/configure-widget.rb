#!/usr/bin/env ruby

# ruby configure-widget.rb RHCSA sher password nav_menu-1 20

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




#driver = Selenium::WebDriver.for :firefox


driver = Selenium::WebDriver.for(:remote , :url=> "http://localhost:2816")
puts 'About to set wait time to 30 seconds'
# http://queirozf.com/entries/selenium-webdriver-with-ruby-examples-and-general-reference
wait = Selenium::WebDriver::Wait.new(:timeout => 30)
target_size = Selenium::WebDriver::Dimension.new(1400, 768)
driver.manage.window.size = target_size
puts driver.manage.window.size



############################################################################
########################### Log into wordpress #############################
############################################################################


# first attempt to login fails, so making a few attempts
begin
  retries ||= 0
  puts "try ##{ retries }"
  sleep(5)
  driver.navigate.to "http://codingbee.net/wp-login.php"
  wait.until { driver.current_url=='http://codingbee.net/wp-login.php'}
rescue
  retry if (retries += 1) < 3
end


user_login_element = driver.find_element(:id, 'user_login')
user_login_element.send_keys "#{wp_web_admin_username}"
puts "Typed in the username as: #{wp_web_admin_username}"
driver.save_screenshot("/var/www/html/configure-widgets_filled-in-username-in-login-page.png")
sleep(5)


user_password_element = driver.find_element(:id, 'user_pass')
user_password_element.send_keys "#{wp_web_admin_user_password}"
puts "Typed in the username as: #{wp_web_admin_user_password}"

driver.save_screenshot("/var/www/html/filled-in-login-page.png")
#user_password_element.submit
sleep(5)

driver.find_element(:id, "wp-submit").click

begin
  retries ||= 0
  puts "Waiting for http://codingbee.net/wp-admin/ to laod - try ##{ retries }"
  driver.save_screenshot("/var/www/html/configure-widgets_screenshot-admin#{retries}.png")
  puts driver.current_url
  sleep(5)
  wait.until { driver.current_url=='http://codingbee.net/wp-admin/'}
rescue
  retry if (retries += 1) < 10
end
sleep(5)

puts 'INFO: Successfully logged into wordpress'




driver.navigate.to "http://codingbee.net/wp-admin/widgets.php"



# first attempt to login fails, so making a few attempts
begin
  retries ||= 0
  puts "try ##{ retries }"
  driver.navigate.to "http://codingbee.net/wp-admin/widgets.php"
  sleep(5)
  driver.save_screenshot("/var/www/html/configure-widgets_screenshot-admin-widgets-page-#{retries}.png")
  wait.until { driver.current_url=='http://codingbee.net/wp-admin/widgets.php'}
rescue
  retry if (retries += 1) < 3
end




widget_header = driver.find_element(:id, 'left').find_element(:xpath, ".//*[contains(., '#{menu_name}')]")
widget_header.click


sleep(2)

select_menu_name_from_dropdown_list = driver.find_element(:class, 'nav-menu-widget-form-controls').find_element(:xpath, "//select[starts-with(@id, 'widget-#{dropdown_menu_html_id}-nav_menu')]")
options_list = select_menu_name_from_dropdown_list.find_elements(:tag_name, "option")
options_list.each do |option|
  puts option.text
  if option.text == menu_name.downcase
     option.click
  end
end


select_visibility_from_dropdown_list = driver.find_element(:id, "widget-#{dropdown_menu_html_id}-dw_include")
options_list = select_visibility_from_dropdown_list.find_elements(:tag_name, "option")
options_list.each do |option|
  puts option.text
  if option.text == 'Show on checked pages'
     option.click
  end
end


category_checkbox = driver.find_element(:id, "widget-#{dropdown_menu_html_id}-cat-#{category_html_id}")
category_checkbox.click

save_button = driver.find_element(:id, "widget-#{dropdown_menu_html_id}-savewidget")
save_button.click

driver.quit


exit

# driver.quit
