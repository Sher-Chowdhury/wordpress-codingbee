#! /usr/bin/env python3.6
# Script for codingbee Activate wordpress licence theme
# 2017 July 03;
# install-theme-licence.py is dependend on selenium
# pip3.6 install -U selenium
# headless starting of program with xvfb-run python3.6 install-theme-licence.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ${premium-theme-licence-key}

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
premium_theme_licence_key = sys.argv[4]

# do not forget to change dir_in values, also few lines bellow geckodriverexecutablePath
if computer == 'l':
    dir_in = "/data/upwork/Sher_Chowdhury/"
else:
    dir_in = "/root/"

log = codecs.open(dir_in + "install-theme-licence-log.txt", "a", "utf-8")
now = str(datetime.datetime.now())[:16]

print('*' * 50)
print(computer)
log.write(now + ' ' + computer + os.linesep)
print(wp_web_admin_username)
log.write(now + ' ' + wp_web_admin_username + os.linesep)
print(wp_web_admin_user_password)
log.write(now + ' ' + wp_web_admin_user_password + os.linesep)
print(premium_theme_licence_key)
log.write(now + ' ' + premium_theme_licence_key + os.linesep)
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
        
    
def set_licence_key():
    '''this is main function for setting licence key'''
    url = "http://codingbee.net/wp-admin/themes.php?page=tc-licenses"
    openurl(url)
    time.sleep(2)
    scroll_topbottom()
    
    try:
        # check is already activate
        xpathactivate = "//input[@value='Activate Key']"        
        elactivate = driver.find_element_by_xpath(xpathactivate)
        # no, elactivate is found, so continue in try block
        
        # clear field and set licence key
        xpathkey = "//input[@name='tc_customizr_pro_license_key']"
        el = driver.find_element_by_xpath(xpathkey)
        el.click()
        el.clear()
        el.send_keys(premium_theme_licence_key)
        print('licence key ' + premium_theme_licence_key + ' set at ' + xpathkey)
        log.write(now + ' licence key ' + premium_theme_licence_key + ' set at ' + xpathkey + os.linesep)
    
        # activate key
        elactivate.click()
        print(xpathactivate + ' clicked')
        log.write(now + ' ' + xpathactivate + ' clicked' + os.linesep)
        
        # save
        xpathsave = "//input[@value='Save Changes']"
        el = driver.find_element_by_xpath(xpathsave)
        el.click()
        print(xpathsave + ' clicked')
        log.write(now + ' ' + xpathsave + ' clicked')
        
    except:
        print('licence key already activated')
        log.write(now + ' licence key already activated')
    
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
    set_licence_key()
    calculate_time()
    log.close()
    driver.close()
    print('Done.')