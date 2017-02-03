require 'selenium-webdriver'

driver = Selenium::WebDriver.for :firefox
driver.navigate.to "http://codingbee.net/wp-login.php"

user_login_element = driver.find_element(:id, 'user_login')

user_login_element.send_keys 'sher'


user_password_element = driver.find_element(:id, 'user_pass')


user_password_element.send_keys 'password'
user_password_element.submit


sleep(5)


driver.navigate.to "http://codingbee.net/wp-admin/admin.php?page=pmxi-admin-settings"

upload_field = driver.find_element(:name, "template_file")

upload_field.send_keys '/Users/schowdhury/Dropbox/codingbee/wp-all-import-exports/import-and-export-plugin-templates/import-templates/import-codingbee-posts-template.txt'

driver.find_element(:name, "import_templates").click

driver.navigate.to "http://codingbee.net/wp-admin/admin.php?page=pmxi-admin-import"

