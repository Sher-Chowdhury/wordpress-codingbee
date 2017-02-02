require 'selenium-webdriver'

driver = Selenium::WebDriver.for :firefox
driver.navigate.to "http://codingbee.net/wp-login.php"

user_login_element = driver.find_element(:id, 'user_login')

user_login_element.send_keys 'sher'


user_password_element = driver.find_element(:id, 'user_pass')


user_password_element.send_keys 'password'
user_password_element.submit


sleep(10)


driver.navigate.to "http://codingbee.net/wp-admin/admin.php?page=pmxi-admin-settings"

