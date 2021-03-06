#!/usr/bin/env ruby

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
puts 'about to start the selenium script'
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




user_login_element = driver.find_element(:id, 'user_login')
user_login_element.send_keys "#{wp_web_admin_username}"
puts "Typed in the username as: #{wp_web_admin_username}"
driver.save_screenshot("/var/www/html/import-posts_filled-in-username-in-login-page.png")
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
  driver.save_screenshot("/var/www/html/screenshot-admin#{retries}.png")
  puts driver.current_url
  sleep(5)
  wait.until { driver.current_url=='http://codingbee.net/wp-admin/'}
rescue
  retry if (retries += 1) < 10
end
sleep(5)

puts 'INFO: Successfully logged into wordpress'

############################################################################
#################### Upload the posts xml payload ##########################
############################################################################


driver.navigate.to "http://codingbee.net/wp-admin/admin.php?page=pmxi-admin-import"

wait.until { driver.current_url=='http://codingbee.net/wp-admin/admin.php?page=pmxi-admin-import'}


## Reached page 1 of the import process. here we:
##   1. select upload-via-http
##   2. click upload button
##   3. then go to next page.

driver.save_screenshot('/var/www/html/import_posts-navigated-to-import-posts-page.png')
driver.find_element(:class, "wpallimport-url-type").click

puts 'INFO: Clicked on the import via url option button'

driver.save_screenshot('/var/www/html/import_posts-clicked-import-via-url-button.png')
xml_payload_input_element = driver.find_element(:name, 'url')
xml_payload_input_element.send_keys 'h'
#xml_payload_input_element.send_keys :backspace , :backspace , :backspace , :backspace , :backspace , :backspace , :backspace , :backspace , :backspace , :backspace
#xml_payload_input_element.send_keys :arrow_right

xml_payload_input_element.send_keys 'ttp://codingbee.net/codingbee-posts-exports.zip'

puts 'INFO: Entered the url'

driver.find_element(:class, "wpallimport-download-from-url").click
sleep(5)

advanced_upload_button = driver.find_element(:id, "advanced_upload")

driver.save_screenshot('/var/www/html/screenshot1b.png')
advanced_upload_button.click
sleep(5)


## Reached page 2 of the import process. here we:
##   1. inspect sample xml data
##   2. then select continue to page 3 button

wait.until { driver.current_url=='http://codingbee.net/wp-admin/admin.php?page=pmxi-admin-import&action=element'}
driver.save_screenshot('/var/www/html/screenshot2.png')

driver.find_element(:xpath, "(//input[@value='Continue to Step 3'])[2]").click
sleep(5)

## Reached page 3 of the import process. here we:
##   1. select template from dropdown list
##   2. click the continue-to-step-4 button

wait.until { driver.current_url=='http://codingbee.net/wp-admin/admin.php?page=pmxi-admin-import&action=template'}
driver.save_screenshot('/var/www/html/screenshot3.png')

puts 'INFO: should have reached the hard part now'
#next_button.location_once_scrolled_into_view

# http://elementalselenium.com/tips/5-select-from-a-dropdown
dropdown_list = driver.find_element(:id, "load_template")
#dropdown_list.click

sleep(5)
driver.save_screenshot('/var/www/html/screenshot11.png')

# had to take this convolated appraoch to select this dropdown list item.
options_list =  dropdown_list.find_elements(:tag_name, "option")
options_list.each do |option|
  if option.text == 'import-codingbee-posts'
     puts option.text
     option.click
  end
end



# the following line doesn't work
#option.select_by(:value, "import-codingbee-posts")


sleep(5)
driver.save_screenshot('/var/www/html/screenshot12.png')

puts 'INFO: Selected template from dropdown list'
driver.save_screenshot('/var/www/html/screenshot5.png')

# next_button = driver.find_element(:class, "wpallimport-large-button")
next_button = driver.find_element(:xpath, "//input[@value='Continue to Step 4']")
puts 'INFO: continue to proceed to step 4'
next_button.click

wait.until { driver.current_url=='http://codingbee.net/wp-admin/admin.php?page=pmxi-admin-import&action=options'}
sleep(5)


puts 'INFO: Reached step 4'


driver.find_element(:class, "wpallimport-auto-detect-unique-key").click

driver.save_screenshot('/var/www/html/screenshot6.png')
driver.find_element(:xpath, "//input[@value='Continue']").click

sleep(5)
driver.save_screenshot('/var/www/html/screenshot7.png')


driver.find_element(:xpath, "(//input[@value='Confirm & Run Import'])[2]").click


#driver.find_element(:class, "add-new-h2").click
#sleep(0)
#driver.find_element(:class, "rad10").click

# allow a minute for the actual import to take place.
sleep(120)
driver.save_screenshot('/var/www/html/screenshot10.png')

############################################################################
########################## End Firefox session #############################
############################################################################
driver.quit
