#!/bin/bash

# Delete the default plugins that came pre-installed.
su -s /bin/bash apache -c 'wp plugin delete hello --path=/var/www/html/'  # removing default plugin
su -s /bin/bash apache -c 'wp plugin delete akismet --path=/var/www/html/'      # removing default plugin


su -s /bin/bash apache -c 'wp plugin install coming-soon --activate --path=/var/www/html/'
su -s /bin/bash apache -c '# wp plugin install custom-admin-bar --activate --path=/var/www/html/'  # broken - try installing manually.
# wp plugin install 'contact-form-7' --activate --path='/var/www/html/'     # gives a warning message, try installing manually.
su -s /bin/bash apache -c 'wp plugin install custom-menu-wizard --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install disable-comments --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install display-widgets --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install duplicate-post --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install google-analytics-for-wordpress --activate --path=/var/www/html/'
# wp plugin install 'save-grab' --activate --path='/var/www/html/'           # broken - try installing manually.
su -s /bin/bash apache -c 'wp plugin install olevmedia-shortcodes --activate --path=/var/www/html/'
# su -s /bin/bash apache -c 'wp plugin install image-elevator --activate --path=/var/www/html/'         # not best practice to use this. will end up making backups too big.
su -s /bin/bash apache -c 'wp plugin install post-content-shortcodes --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install post-editor-buttons-fork --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install publish-view --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install recently-edited-content-widget --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install rel-nofollow-checkbox --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install search-filter --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install syntaxhighlighter --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install table-of-contents-plus --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install tablepress --activate --path=/var/www/html/'
su -s /bin/bash apache -c 'wp plugin install wp-github-gist --activate --path=/var/www/html/'
#su -s /bin/bash apache -c 'wp plugin install wordpress-importer --activate --path=/var/www/html/'
