#!/bin/bash


# note, a random password is generated for the new user.
su -s /bin/bash apache -c "wp user create guestadmin guestadmin@example.com --role=administrator --path=/var/www/html"
su -s /bin/bash apache -c "wp user create guesteditor guesteditor@example.com --role=editor --path=/var/www/html"
