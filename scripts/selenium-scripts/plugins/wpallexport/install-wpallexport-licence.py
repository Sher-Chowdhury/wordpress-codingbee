#! /usr/bin/env python3.6
# Script for codingbee Activate wpallexport plugin
# 2017 July 03;
# install-wpallexport-licence.py is dependend on selenium
# pip3.6 install -U selenium
# headless starting of program with xvfb-run python3.6 install-wpallexport-licence.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ${wpallexport-licence-key}

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
import time
import html
import os
import re
import sys
import codecs

# computer can be 'l' for local testing or any other value like 's' for digitalocean server

computer = sys.argv[1]
wp_web_admin_username = sys.argv[2]
wp_web_admin_user_password = sys.argv[3]
wpallexport_licence_key = sys.argv[4]

# do not forget to change dir_in values, also few lines bellow geckodriverexecutablePath
if computer == 'l':
    dir_in = "/data/upwork/Sher_Chowdhury/"
else:
    dir_in = "/root/"

log = codecs.open(dir_in + "install-wpallexport-licence-log.txt", "a", "utf-8")
now = str(datetime.datetime.now())[:16]

print('*' * 50)
print(computer)
log.write(now + ' ' + computer + os.linesep)
print(wp_web_admin_username)
log.write(now + ' ' + wp_web_admin_username + os.linesep)
print(wp_web_admin_user_password)
log.write(now + ' ' + wp_web_admin_user_password + os.linesep)
print(wpallexport_licence_key)
log.write(now + ' ' + wpallexport_licence_key + os.linesep)
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
    el.send_keys(wp_web_admin_username)
    xpath = "//input[@id='user_pass']"
    el = driver.find_element_by_xpath(xpath)
    el.click()
    el.clear()
    el.send_keys(wp_web_admin_user_password)
    xpath = "//input[@id='wp-submit']"
    el = driver.find_element_by_xpath(xpath)
    el.click()
    time.sleep(3)
    # make sure that page is loaded
    xpath = "//a[contains(.,'Codingbee')]"
    waitForLoadbyXpath(xpath)
    if is_element_present(xpath):
        print('login successful')
        log.write(now + ' login successful' + os.linesep)
    else:
        print('problems with login...')
        log.write(now + ' problems with login...')
        log.close()
        sys.exit()
        
    
def activate_wpallexport():
    '''this is main function for wpallimport activation'''
    url = "http://codingbee.net/wp-admin/admin.php?page=pmxe-admin-settings"
    openurl(url)
    time.sleep(2)
    scroll_topbottom()
    
    # first check is key already activated
    xpathactive = "//p[contains(.,'Active') and contains(@style,'color:green')]"
    if is_element_present(xpathactive):
        print('Already active')
        log.write(now + ' Already active')
        
    else:
        # not Active, set licence key
        xpathkey = "//input[@name='license']"
        elkey = driver.find_element_by_xpath(xpathkey)
        elkey.click()
        elkey.clear()
        elkey.send_keys(wpallexport_licence_key)
        print(wpallexport_licence_key + ' set at ' + xpathkey)
        log.write(now + ' ' + wpallexport_licence_key + ' set at ' + xpathkey + os.linesep)
        
        xpathsave = "//input[@value='Save Settings']"
        elsave = driver.find_element_by_xpath(xpathsave)
        elsave.click()
        print(xpathsave + ' clicked')
        log.write(now + ' ' + xpathsave + ' clicked')
    
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
    activate_wpallexport()
    calculate_time()
    log.close()
    driver.close()
    print('Done.')