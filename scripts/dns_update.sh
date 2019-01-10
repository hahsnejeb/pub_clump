#!/bin/bash

new_ip=`curl ifconfig.co`

if [ -z $new_ip ]; then
  echo "Usage: #dns_update.sh <new_ip>"
  exit
fi

dir=/var/named/chroot/var/named
file=$dir/db.hahsnejeb.co.uk.EXT
old_ip=$(grep "IN.*A.*[0-9].*$" $file|awk '{print $4}'|sed '/^$/d'|sort|uniq)
date=$(date '+%y%m%d%H%M%S')
old_serial=$(grep serial $file)

cd $dir
cp $file $file.$date
sed -i "s/$old_ip/$new_ip/g" $file
sed -i "s/$old_serial/\t\t\t$date\t\; serial/" $file

service named restart

