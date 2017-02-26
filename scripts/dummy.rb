require 'selenium-webdriver'
#require 'headless'   # using phantomjs instead since it can do whole page screenshots

# Added the following line to output to jenkins console in realtime. 
STDOUT.sync = true

############################################################################
######################## Start Firefox session #############################
############################################################################

#headless = Headless.new


#headless.start
#driver = Selenium::WebDriver.for :firefox

sleep(5)
puts 'about to start the dummy selenium script'
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

user_login_element.send_keys 'sher'


user_password_element = driver.find_element(:id, 'user_pass')


user_password_element.send_keys 'password'
#user_password_element.submit

driver.find_element(:id, "wp-submit").click

begin
  retries ||= 0
  puts "Waiting for http://codingbee.net/wp-admin/ to laod - try ##{ retries }"
  driver.save_screenshot("/var/www/html/screenshot-admin#{retries}.png")
  puts driver.current_url
  sleep(5)
  wait.until { driver.current_url=='http://codingbee.net/wp-admin/'}
rescue
  retry if (retries += 1) < 3 
end
sleep(5)

puts 'INFO: Dummy over'

driver.quit
