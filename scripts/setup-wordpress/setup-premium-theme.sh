#!/bin/bash

xvfb-run python3.6 setup-premium-thmeme.py s ${wp_web_admin_username} ${wp_web_admin_user_password} ${premium_theme_licence_key}
