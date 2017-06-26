#! /usr/bin/env python3.6
# Script for codingbee python automation
# Aleksandar Josifoski for Sher Chowdhury
# 2017 June 25;
# widgetspy_xy.py is dependend on selenium
# pip3 install -U selenium
# headless starting of program with xvfb-run python3.6 widgetspy_xy.py sher password nav_menu-11 16

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
computer = 's'

username = sys.argv[1]
password = sys.argv[2]
dropdown_menu_html_id = sys.argv[3]
category_html_id = sys.argv[4]
print('*' * 50)
print(username)
print(password)
print(dropdown_menu_html_id)
print(category_html_id)
print('*' * 50)

# in case you want entering username and password via executing script python3 widgetspy_01.py sher password
# uncomment following line and delete above lines
# username = sys.argv[1]
# password = sys.argv[2]

if computer == 'l':
    dir_in = "/data/upwork/Sher_Chowdhury/"
else:
    dir_in = "/home/guestadmin/"
    
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
ffWidth = 1280
ffHeight = 800

log = codecs.open(dir_in + "widgetspy_errorslog.txt", "a", "utf-8")
time1 = time.time()
driver = None
wait = None

def open_tag_by_css(css_selector):
    '''function to click item based on css selector'''
    driver.find_element_by_css_selector(css_selector).click()

def open_tag_by_xpath(xpath):
    '''function to click item based on xpath'''
    driver.find_element_by_xpath(xpath).click()

def enter_in_tag_by_css(css_selector, text):
    '''function to enter text based on css selector'''
    driver.find_element_by_css_selector(css_selector).send_keys(text)

def enter_in_tag_by_xpath(xpath, text):
    '''function to enter text based on xpath'''
    driver.find_element_by_xpath(xpath).send_keys(text)

def save_response_to_file(text):
    '''temporary function to analyse html response'''
    with codecs.open(dir_in + "rawresponse.txt", "w", "utf-8") as fresp:
        fresp.write(html.unescape(text))

def waitForLoadbyCSS(CSS_SELECTOR):
    '''function to wait until web element is available via css check'''
    wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, CSS_SELECTOR)))

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
        now = str(datetime.datetime.now())[:16]
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
    else:
        print('problems with login...')
        sys.exit()
        
    
def setwidget():
    '''this is main function for setting widget'''
    url = "http://codingbee.net/wp-admin/widgets.php"
    openurl(url)
    time.sleep(2)
    scroll_down(400)
    
    # Select Custom Menu: python
    xpath = "//h3[contains(.,'Custom Menu: python')]"
    el = driver.find_element_by_xpath(xpath)
    el.click()
    print(xpath + ' clicked')
    time.sleep(1)
    
    # python from first drop down menu
    xpath = "//select[contains(@id, 'widget-%s')]" % dropdown_menu_html_id
    value = "python"
    el = Select(driver.find_element_by_xpath(xpath))
    el.select_by_visible_text(value)
    print(xpath + ' clicked')
    print(value + ' set')
    time.sleep(1)
    
    # Show on checked pages
    xpath = "//select[contains(@name,'extended_widget_opts-%s')]" % dropdown_menu_html_id
    value = "Show on checked pages"
    el = Select(driver.find_element_by_xpath(xpath))
    el.select_by_visible_text(value)
    print(xpath + ' clicked')
    print(value + ' set')    
    time.sleep(1)
    
    scroll_down(200)
    #click on taxonomies
    xpath = "//a[contains(@href,'%s-tax')]" % dropdown_menu_html_id
    el = driver.find_element_by_xpath(xpath)
    el.click()
    print(xpath + ' clicked')
    time.sleep(0.5)
    
    #click on Python
    xpath = "//input[contains(@id, '%s') and contains(@id, 'categories-%s')]" % (dropdown_menu_html_id, category_html_id)
    el = driver.find_element_by_xpath(xpath)
    el.click()
    print(xpath + ' clicked')
    time.sleep(1)
    
    # save
    xpath = "//input[contains(@id,'%s-savewidget')]" % dropdown_menu_html_id
    el = driver.find_element_by_xpath(xpath)
    print(xpath + ' clicked')
    el.click()
    
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
    setwidget()
    calculate_time()
    log.close()
    driver.close()
    print('Done.')
