require 'selenium-webdriver'
#require 'headless'   # using phantomjs instead since it can do whole page screenshots

# Added the following line to output to jenkins console in realtime.
STDOUT.sync = true

wp_web_admin_username = ARGV[0]
wp_web_admin_user_password = ARGV[1]
puts "The wordpress frontend admin username: #{wp_web_admin_username}"
puts "The wordpress frontend admin password: #{wp_web_admin_user_password}"

############################################################################
######################## Start Firefox session #############################
############################################################################

#headless = Headless.new


#headless.start
#driver = Selenium::WebDriver.for :firefox

sleep(5)
puts 'INFO: about to start the impex template import selenium script'
driver = Selenium::WebDriver.for(:remote , :url=> "http://localhost:2816")

sleep(5)

puts 'About to set wait time to 30 seconds'
# http://queirozf.com/entries/selenium-webdriver-with-ruby-examples-and-general-reference
wait = Selenium::WebDriver::Wait.new(:timeout => 30)
puts 'Finished setting wait time'

puts 'INFO: Created new browser session successfully'


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

begin
  retries ||= 0
  puts "Waiting for http://codingbee.net/wp-admin/ to laod - try ##{ retries }"
  driver.save_screenshot("/var/www/html/screenshot-admin#{retries}.png")

  driver.navigate.to "http://codingbee.net/wp-login.php"
  wait.until { driver.current_url=='http://codingbee.net/wp-login.php'}
  user_login_element = driver.find_element(:id, 'user_login')
  user_login_element.send_keys "#{wp_web_admin_username}"
  user_password_element = driver.find_element(:id, 'user_pass')
  user_password_element.send_keys "#{wp_web_admin_user_password}"
  driver.find_element(:id, "wp-submit").click
  puts "current url is still driver.current_url"
  sleep(5)
  wait.until { driver.current_url=='http://codingbee.net/wp-admin/'}
rescue
  retry if (retries += 1) < 10
end
sleep(5)

puts 'INFO: Successfully logged into wordpress'

############################################################################
############ Upload xml-to-post-mapping-import-template ####################
############################################################################

driver.navigate.to "http://codingbee.net/wp-admin/admin.php?page=pmxi-admin-settings"
wait.until { driver.current_url=='http://codingbee.net/wp-admin/admin.php?page=pmxi-admin-settings'}

upload_field = driver.find_element(:name, "template_file")

upload_field.send_keys '/root/downloads/wp-all-import-exports/import-and-export-plugin-templates/import-templates/import-codingbee-posts-template.txt'


driver.find_element(:name, "import_templates").click
sleep(10)

puts 'INFO: Successfully uploaded xml (import) mapping template'


############################################################################
############ Upload xml-to-post-mapping-export-template ####################
############################################################################


driver.navigate.to "http://codingbee.net/wp-admin/admin.php?page=pmxe-admin-settings"
wait.until { driver.current_url=='http://codingbee.net/wp-admin/admin.php?page=pmxe-admin-settings'}

upload_field = driver.find_element(:name, "template_file")

upload_field.send_keys '/root/downloads/wp-all-import-exports/import-and-export-plugin-templates/export-templates/export-codingbee-posts-template.txt'


driver.find_element(:name, "import_templates").click
sleep(10)

puts 'INFO: Successfully uploaded  xml (export) mapping template'



sleep(10)

driver.quit
