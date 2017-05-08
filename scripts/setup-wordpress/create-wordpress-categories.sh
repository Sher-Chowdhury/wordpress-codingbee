#!/bin/bash

for line in `cat /root/downloads/categories.csv` ; do

  echo $line
  name=`echo $line | cut -d',' -f1`
  slug=`echo $line | cut -d',' -f2`
  parent=`echo $line | cut -d',' -f3`
  echo "The name is ${name}"
  echo "The slug is ${slug}"
  echo "The parent is ${parent}"

  parent_id=`wp term list category --fields=name,term_id --path=/var/www/html/ | grep ${parent} | awk '{print $4;}'`

  echo "The parent_id is ${parent_id}"
  wp term create category ${name} --slug=${slug} --parent=${parent_id} --path=/var/www/html/
done
