#!/bin/bash

xvfb-run python3.6 setup-backupbuddy.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ${backupbuddy_username} ${backupbuddy_password}
