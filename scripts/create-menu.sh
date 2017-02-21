#!/bin/bash

IFS=$'\n'
cd /root/downloads/menus
for csvfile in `ls *.csv`; do
  menu_title=`basename ${csvfile} .csv`
  echo "About to create menu called ${menu_title}"
  menu_id=`wp menu create "${menu_title}" --porcelain --path=/var/www/html`
  echo "The menu ${menu_title} has the id: ${menu_id}"

  for line in `cat /root/downloads/menus/$csvfile`; do
    echo "about to process: $line"
    post_title=`echo ${line} | awk 'BEGIN {FS=":::"} {print $1}' 
    parent_post_title=`echo ${line} | awk 'BEGIN {FS=":::"} {print $2}'`
    menu_label=`echo ${line} | awk 'BEGIN {FS=":::"} {print $3}'`

    #echo "The post title is ${post_title}"
    #echo "The parent post title is ${parent_post_title}"
    #echo "The menu item label is ${menu_label}"


    if [[ ${parent_post_title} == 'null' && ${menu_label} == 'null' ]] ; then
       post_id=`wp post list --path=/var/www/html --fields=ID,post_title | grep "${post_title}" | awk '{print $2;}'`
       #echo "the post_id is ${post_id}"
       echo "About to add a simple parent menu item"
       echo "about to run: wp menu item add-post ${menu_title} ${post_id} --path=/var/www/html"
       wp menu item add-post ${menu_title} ${post_id} --path=/var/www/html
    fi


    if [[ ${parent_post_title} != 'null' && ${menu_label} == 'null' ]] ; then
       post_id=`wp post list --path=/var/www/html --fields=ID,post_title | grep "${post_title}" | awk '{print $2;}'`
       parent_post_id=`wp post list --path=/var/www/html --fields=ID,post_title | grep "${parent_post_title}" | awk '{print $2;}'`
      # echo "the post_id is ${post_id}"
      # echo "the post_id is ${parent_post_title} which has the id ${parent_post_id}"
       echo "About to add a simple child menu item"
       db_id=`wp menu item list RHCSA --path=/var/www/html --fields=db_id,title,object_id | grep "${parent_post_id} *|$" | awk '{print $2}'`
       echo "wp menu item add-post ${menu_title} ${post_id} --parent-id=${db_id} --path=/var/www/html"
       wp menu item add-post ${menu_title} ${post_id} --parent-id=${db_id} --path=/var/www/html
    fi


    if [[ ${parent_post_title} == 'null' && ${menu_label} != 'null' ]] ; then
       post_id=`wp post list --path=/var/www/html --fields=ID,post_title | grep "${post_title}" | awk '{print $2;}'`
       #echo "the post_id is ${post_id}"
       echo "About to add a parent menu item with custom label"
       echo "about to run: wp menu item add-post ${menu_title} ${post_id} --title=${menu_label} --path=/var/www/html"
       wp menu item add-post ${menu_title} ${post_id} --title=${menu_label} --path=/var/www/html
    fi

    if [[ ${parent_post_title} != 'null' && ${menu_label} != 'null' ]] ; then
       post_id=`wp post list --path=/var/www/html --fields=ID,post_title | grep "${post_title}" | awk '{print $2;}'`
       parent_post_id=`wp post list --path=/var/www/html --fields=ID,post_title | grep "${parent_post_title}" | awk '{print $2;}'`
       #echo "the post_id is ${post_id}"
       echo "About to add a child menu item with custom menu"
       db_id=`wp menu item list RHCSA --path=/var/www/html --fields=db_id,title,object_id | grep "${parent_post_id} *|$" | awk '{print $2}'`
       echo "about to run: wp menu item add-post ${menu_title} ${post_id} --title=${menu_label} --parent-id=${db_id} --path=/var/www/html"
       wp menu item add-post ${menu_title} ${post_id} --title=${menu_label} --parent-id=${db_id} --path=/var/www/html
    fi


  done
  # wp sidebar list --fields=name,id --path=/var/www/html
  # wp widget list left --path=/var/www/html
  # wp widget add custom-menu-wizard left --path=/var/www/html
done
