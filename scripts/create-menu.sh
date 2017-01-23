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
    menu_label=`echo ${line} | cut -d',' -f3`

    echo "The post title is ${post_title}"
    echo "The parent post title is ${parent_post_title}"
    echo "The menu item label is ${menu_label}"


    if [[ ${parent_post_title} == 'null' && ${menu_label} == 'null' ]] ; then
       post_id=`wp post list --path=/var/www/html --fields=ID,post_title | grep "${post_title}" | awk '{print $2;}'`
       echo "the post_id is ${post_id}"
       echo "about to run: wp menu item add-post ${menu_title} ${post_id} --path=/var/www/html"
       wp menu item add-post ${menu_title} ${post_id} --path=/var/www/html
    fi


    if [[ ${parent_post_title} != 'null' && ${menu_label} == 'null' ]] ; then
       post_id=`wp post list --path=/var/www/html --fields=ID,post_title | grep "${post_title}" | awk '{print $2;}'`
       parent_post_id=`wp post list --path=/var/www/html --fields=ID,post_title | grep "${parent_post_title}" | awk '{print $2;}'`
       echo "the post_id is ${post_id}"
       echo "the post_id is ${parent_post_title} which has the id ${parent_post_id}"
       echo "wp menu item add-post ${menu_title} ${post_id} --parent-id=${parent_post_id} --path=/var/www/html"
       wp menu item add-post ${menu_title} ${post_id} --parent-id=${parent_post_id} --path=/var/www/html
    fi


    if [[ ${parent_post_title} == 'null' && ${menu_label} != 'null' ]] ; then
       post_id=`wp post list --path=/var/www/html --fields=ID,post_title | grep "${post_title}" | awk '{print $2;}'`
       echo "the post_id is ${post_id}"
       echo "about to run: wp menu item add-post ${menu_title} ${post_id} --title=${menu_label} --path=/var/www/html"
       wp menu item add-post ${menu_title} ${post_id} --title=${menu_label} --path=/var/www/html
    fi

    if [[ ${parent_post_title} != 'null' && ${menu_label} != 'null' ]] ; then
       post_id=`wp post list --path=/var/www/html --fields=ID,post_title | grep "${post_title}" | awk '{print $2;}'`
       parent_post_id=`wp post list --path=/var/www/html --fields=ID,post_title | grep "${parent_post_title}" | awk '{print $2;}'`
       echo "the post_id is ${post_id}"
       echo "about to run: wp menu item add-post ${menu_title} ${post_id} --title=${menu_label} --parent-id=${parent_post_id} --path=/var/www/html"
       wp menu item add-post ${menu_title} ${post_id} --title=${menu_label} --parent-id=${parent_post_id} --path=/var/www/html
    fi


  done
  # wp widget add "Custom Menu Wizard" left --path=/var/www/html
done
