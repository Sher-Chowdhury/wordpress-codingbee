#!/bin/bash

wp_db_name=${1}

mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = replace(post_content, "â””â”€â”¬", "└─┬");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = REPLACE(post_content, "â””â”€â”€", "└──");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = REPLACE(post_content, "â”œâ”€â”€", "├──");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = REPLACE(post_content, "â”œâ”€", "├─");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = REPLACE(post_content, "â””â”€", "└─");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = replace(post_content, "â”‚", "│");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = replace(post_content, "Â", " ");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = replace(post_content, "â€", "”");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = replace(post_content, "â€", "-");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = replace(post_content, "Ö˜", "X");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = REPLACE(post_content, "â€œ", "“");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = REPLACE(post_content, "â€™", "’");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = REPLACE(post_content, "â€˜", "‘");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = REPLACE(post_content, "â€”", "-");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = REPLACE(post_content, "â€“", "-");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = REPLACE(post_content, "â€¢", "-");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = REPLACE(post_content, "â€¦", "…");'
mysql -u root -D $wp_db_name -e 'UPDATE wp_posts SET post_content = REPLACE(post_content, "â€£", "‣");'
