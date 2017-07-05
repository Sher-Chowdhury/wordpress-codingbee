#! /usr/bin/env python3.6
# Script for codingbee upload a file (for custom theme settings)
# 2017 July 03;
# import-theme-customizater-settings.py is dependend on selenium
# pip3.6 install -U selenium
# headless starting of program with xvfb-run python3.6 import-theme-customizater-settings.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ${absolute_path_to_json_file}

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
absolute_path_to_json_file = sys.argv[4]

# do not forget to change dir_in values, also few lines bellow geckodriverexecutablePath
if computer == 'l':
    dir_in = "/data/upwork/Sher_Chowdhury/"
else:
    dir_in = "/root/"

log = codecs.open(dir_in + "import-theme-customizater-settings-log.txt", "a", "utf-8")
now = str(datetime.datetime.now())[:16]

print('*' * 50)
print(computer)
log.write(now + ' ' + computer + os.linesep)
print(wp_web_admin_username)
log.write(now + ' ' + wp_web_admin_username + os.linesep)
print(wp_web_admin_user_password)
log.write(now + ' ' + wp_web_admin_user_password + os.linesep)
print(absolute_path_to_json_file)
log.write(now + ' ' + absolute_path_to_json_file + os.linesep)
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

def upload_a_file_custom_theme_settings():
    '''this is main function for uploading file (custom theme settings)'''
    # This is direct access to url
    url = "http://codingbee.net/wp-admin/customize.php?return=%2Fwp-admin%2Fadmin.php%3Fpage%3Dtablepress_import"
    # If needed xpath for Appearance = .//*[@id='menu-appearance']/a/div[3] xpath for Customize = .//*[@id='menu-appearance']/ul/li[3]/a
    openurl(url)
    time.sleep(2)
    
    # waiting for page to load, waiting for title
    xpathwait = "//a[@class='site-title']"
    waitForLoadbyXpath(xpathwait)
    scroll_topbottom()
    
    # click on Export/Import
    xpathexpimp = "//h3[contains(.,'Export/Import') and contains(.,'open this section')]"
    elexpimp = driver.find_element_by_xpath(xpathexpimp)
    elexpimp.click()
    print(xpathexpimp + ' clicked')
    log.write(now + ' ' + xpathexpimp + ' clicked' + os.linesep)
    time.sleep(1)
    
    # set file
    xpathbrowse = "//input[@name='cei-import-file']"
    elbrowse = driver.find_element_by_xpath(xpathbrowse)
    try:
        elbrowse.send_keys(absolute_path_to_json_file)
        print(absolute_path_to_json_file + ' found and set')
        log.write(now + ' ' + absolute_path_to_json_file + ' found and set' + os.linesep)
        time.sleep(1)
    except:
        print('not valid path ' + absolute_path_to_json_file)
        log.write(now + ' ' + 'not valid path ' + absolute_path_to_json_file)
        log.close()
        sys.exit()
    
    # click on import
    xpathimpbutton = "//input[@name='cei-import-button']"
    elimpbutton = driver.find_element_by_xpath(xpathimpbutton)
    elimpbutton.click()
    print(xpathimpbutton + ' clicked' + os.linesep)
    log.write(now + ' ' + xpathimpbutton + ' clicked' + os.linesep)
    
    # check validity of import, if popup shows then is not valid
    try:
        wait.until(EC.alert_is_present())
        bOK = False
    except:
        bOK = True
        
    if bOK:
        print(absolute_path_to_json_file + ' imported successfully')
        log.write(now + ' ' + absolute_path_to_json_file + ' imported successfully')
    else:
        print(absolute_path_to_json_file + ' not imported')
        log.write(now + ' ' + absolute_path_to_json_file + ' not imported')

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
    upload_a_file_custom_theme_settings()
    calculate_time()
    log.close()
    driver.close()
    print('Done.')