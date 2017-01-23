#!/bin/bash

IFS=$'\n'
for csvfile in `ls /root/downloads/menus`; do
  menu_title=`basename ${csvfile} .csv`
  echo "About to create menu called ${menu_title}"
  menu_id=`wp menu create "${menu_title}" --porcelain --path=/var/www/html`
  echo "The menu ${menu_title} has the id: ${menu_id}"

  for line in `cat /root/downloads/menus/$csvfile`; do
    echo "about to process: $line"
    post_title=`echo ${line} | cut -d',' -f1`
    parent_post_title=`echo ${line} | cut -d',' -f2`

    echo "The post title is ${post_title}"
    echo "The parent post title is ${parent_post_title}"

    if [ ${parent_post_title} == 'null' ] ; then
       echo "no parent"
       post_id=`wp post list --path=/var/www/html --fields=ID,post_title | grep "$post_title" | awk '{print $2;}'`
       echo "the post_id is ${post_id}"
       echo "about to run: wp menu item add-post ${menu_title} ${post_id} --path=/var/www/html"
       wp menu item add-post ${menu_title} ${post_id} --path=/var/www/html
    else
       echo "parent found"
    fi



  done
  # wp widget add "Custom Menu Wizard" left --path=/var/www/html
done
