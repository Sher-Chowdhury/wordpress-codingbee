#! /usr/bin/env python3.6
# Script for codingbee configure search widget
# 2017 July 03;
# configure-search-widget.py is dependend on selenium
# pip3.6 install -U selenium
# headless starting of program with xvfb-run python3.6 configure-search-widget.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ${content}
# for using multiline content, use %n for splitting lines. Blanks can be left as is.

from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.common.keys import Keys
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support.ui import Select
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import datetime
import random
import time
import html
import os
import re
import sys
import codecs

# computer can be 'l' for local testing or any other value like 's' for digitalocean server

computer = sys.argv[1]
username = sys.argv[2]
password = sys.argv[3]
content = ' '.join(sys.argv[4:])
lcontent = content.split('%n')

now = str(datetime.datetime.now())[:16]

# do not forget to change dir_in values, also few lines bellow geckodriverexecutablePath
if computer == 'l':
    dir_in = "/data/upwork/Sher_Chowdhury/"
else:
    dir_in = "/root/"

log = codecs.open(dir_in + "configure-search-widget-log.txt", "a", "utf-8")

print('*' * 50)
print(computer)
log.write(now + ' ' + computer + os.linesep)
print(username)
log.write(now + ' ' + username + os.linesep)
print(password)
log.write(now + ' ' + password + os.linesep)
print(lcontent)
log.write(now + ' ' + str(lcontent) + os.linesep)
print('*' * 50)

timeout = 10
# using geckodriver
# set value to integer 1 (with 0 selenium will try to work with default firefox browser)
# newest geckodriver executable can be downloaded from https://github.com/mozilla/geckodriver/releases
# unpacked and placed in some directory, where in next line full absolute path to geckodriver executable will be set
if computer == 'l':
    geckodriverexecutablePath = "/data/Scrape/geckodriver"
else:
    geckodriverexecutablePath = "/usr/bin/geckodriver"
usegecko = True
time1 = time.time()
driver = None
wait = None

def save_response_to_file(text):
    '''temporary function to analyse html response'''
    with codecs.open(dir_in + "rawresponse.txt", "w", "utf-8") as fresp:
        fresp.write(html.unescape(text))

def waitForLoadbyXpath(xpath):
    '''function to wait until web element is available via xpath check'''
    try:
        wait.until(EC.presence_of_element_located((By.XPATH, xpath)))
        return True
    except:
        return False

def openurl(url):
    '''function to open url using selenium'''
    try:
        driver.get(url)
        print('loading ' + url)
    except Exception as e:
        log.write(now + ' ' + str(e) + os.linesep)
        print(str(e))

def setbrowser():
    ''' function for preparing browser for automation '''
    print("Preparing browser")
    global driver
    global wait
    capabilities = DesiredCapabilities.FIREFOX
    capabilities['acceptInsecureCerts'] = True
    if usegecko:
        capabilities["marionette"] = True
    profile = webdriver.firefox.firefox_profile.FirefoxProfile()
    profile.default_preferences["webdriver_assume_untrusted_issuer"] = False
    profile.update_preferences()
    driver = webdriver.Firefox(firefox_profile=profile,
                               capabilities = capabilities,
                               executable_path = geckodriverexecutablePath)
    driver.implicitly_wait(timeout)
    wait = WebDriverWait(driver, timeout)

def scroll_down(sbypx):
    '''function for scrolling down by px'''
    driver.execute_script("window.scrollBy(0, %d);" % (sbypx))
    time.sleep(0.3)
    
def scroll_topbottom():
    '''function for scrolling top to bottom'''
    driver.execute_script("window.scrollTo(0, 0);")
    time.sleep(0.2)
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    time.sleep(0.3)

def is_element_present(xpath):
    '''checking is element present based on xpath'''
    try:
        driver.find_element_by_xpath(xpath)
        bprocess = True
    except:
        bprocess = False
    return bprocess

def login():
    '''function to log on page'''
    url = "http://codingbee.net/wp-login.php"
    openurl(url)
    time.sleep(1)
    xpath = "//input[@id='user_login']"
    waitForLoadbyXpath(xpath)
    el = driver.find_element_by_xpath(xpath)
    el.click()
    el.clear()
    el.send_keys(username)
    xpath = "//input[@id='user_pass']"
    el = driver.find_element_by_xpath(xpath)
    el.click()
    el.clear()
    el.send_keys(password)
    xpath = "//input[@id='wp-submit']"
    el = driver.find_element_by_xpath(xpath)
    el.click()
    time.sleep(3)
    # make sure that page is loaded
    xpath = "//a[contains(.,'Codingbee')]"
    waitForLoadbyXpath(xpath)
    if is_element_present(xpath):
        print('login successful')
        log.write(now + ' ' + 'login successful' + os.linesep)
    else:
        print('problems with login...')
        log.write(now + ' ' + 'problems with login...')
        sys.exit()


def configure_search_widget():
    '''this is main function for search widget configuration'''
    url = "http://codingbee.net/wp-admin/widgets.php"
    openurl(url)
    time.sleep(2)
    scroll_topbottom()

    # Select Custom Menu: $menu_name
    xpath = "//h3[contains(.,'Text:') and contains(.,'Search')]"
    el = driver.find_element_by_xpath(xpath)
    el.click()
    print(xpath + ' clicked')
    log.write(now + ' ' + xpath + ' clicked' + os.linesep)
    time.sleep(1)

    # click on text tag
    xpath = "//button[@class='wp-switch-editor switch-html']"
    el = driver.find_element_by_xpath(xpath)
    el.click()
    print(xpath + ' clicked')
    log.write(now + ' ' + xpath + ' clicked' + os.linesep)
    time.sleep(1)

    # enter $content
    xpath = "//textarea[@class='widefat text wp-editor-area']"
    el = driver.find_element_by_xpath(xpath)
    el.click()
    el.clear()
    print(xpath + ' clicked')
    log.write(now + ' ' + xpath + ' clicked and cleared' + os.linesep)    
    for line in lcontent:
        el.send_keys(line)
        el.send_keys(Keys.ENTER)
        print('inserted ' + line)
        log.write(now + ' inserted ' + line + os.linesep)

    time.sleep(3)

def calculate_time():
    '''function to calculate elapsed time'''
    time2 = time.time()
    hours = int((time2-time1)/3600)
    minutes = int((time2-time1 - hours * 3600)/60)
    sec = time2 - time1 - hours * 3600 - minutes * 60
    print("processed in %dh:%dm:%ds" % (hours, minutes, sec))

if __name__ == '__main__':
    setbrowser()
    login()
    configure_search_widget()
    calculate_time()
    log.close()
    driver.close()
    print('Done.')