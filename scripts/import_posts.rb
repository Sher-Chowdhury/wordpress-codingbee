require 'selenium-webdriver'
require 'headless'


############################################################################
######################## Start Firefox session #############################
############################################################################

headless = Headless.new


headless.start
driver = Selenium::WebDriver.for :firefox

# http://queirozf.com/entries/selenium-webdriver-with-ruby-examples-and-general-reference
wait = Selenium::WebDriver::Wait.new(:timeout => 30)

############################################################################
########################### Log into wordpress #############################
############################################################################
driver.navigate.to "http://codingbee.net/wp-login.php"

user_login_element = driver.find_element(:id, 'user_login')

user_login_element.send_keys 'sher'


user_password_element = driver.find_element(:id, 'user_pass')


user_password_element.send_keys 'password'
user_password_element.submit


sleep(5)


############################################################################
################ Upload xml-to-post-mapping-template #######################
############################################################################


driver.navigate.to "http://codingbee.net/wp-admin/admin.php?page=pmxi-admin-settings"

upload_field = driver.find_element(:name, "template_file")

upload_field.send_keys '/root/downloads/wp-all-import-exports/import-and-export-plugin-templates/import-templates/import-codingbee-posts-template.txt'

driver.find_element(:name, "import_templates").click



############################################################################
#################### Upload the posts xml payload ##########################
############################################################################



driver.navigate.to "http://codingbee.net/wp-admin/admin.php?page=pmxi-admin-import"

driver.find_element(:class, "wpallimport-url-type").click


xml_payload_input_element = driver.find_element(:name, 'url')


xml_payload_input_element.send_keys 'h'
#xml_payload_input_element.send_keys :backspace , :backspace , :backspace , :backspace , :backspace , :backspace , :backspace , :backspace , :backspace , :backspace


#xml_payload_input_element.send_keys :arrow_right

xml_payload_input_element.send_keys 'ttp://codingbee.net/codingbee-posts-exports.zip'


driver.find_element(:class, "wpallimport-download-from-url").click

sleep(5)

driver.find_element(:id, "advanced_upload").click

wait.until { driver.current_url=='http://codingbee.net/wp-admin/admin.php?page=pmxi-admin-import&action=element'}
sleep(5)

driver.find_element(:class, "wpallimport-large-button").click

wait.until { driver.current_url=='http://codingbee.net/wp-admin/admin.php?page=pmxi-admin-import&action=template'}
sleep(5)

dropdownmenu = driver.find_element(:id, "load_template")

option = Selenium::WebDriver::Support::Select.new(dropdownmenu)


option.select_by(:text, 'import-codingbee-posts')

sleep(5)

driver.find_element(:class, "wpallimport-large-button").click
wait.until { driver.current_url=='http://codingbee.net/wp-admin/admin.php?page=pmxi-admin-import&action=options'}
sleep(5)

driver.find_element(:class, "wpallimport-auto-detect-unique-key").click

driver.save_screenshot('/var/www/html/screenshot1.png')
driver.find_element(:name, "save_only").click

sleep(5)
driver.save_screenshot('/var/www/html/screenshot2.png')
driver.find_element(:class, "add-new-h2").click
sleep(20)
driver.find_element(:class, "rad10").click

# allow a minute for the actual import to take place.
sleep(60)


############################################################################
########################## End Firefox session #############################
############################################################################
driver.quit
headless.destroy
