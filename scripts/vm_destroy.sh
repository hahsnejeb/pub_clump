#!/bin/bash


name=$1

if [ -z $name ];then
  echo "Usage: #vm_destroy.sh <hostname>"
  exit
fi

################################################################################
# Output current VM status                                                     #
################################################################################
echo "Current Configured VMs:"
virsh list --all --title
#echo "Continue? [y]"
#read continue
#if [ ${continue} != "y" ]; then echo "Exiting.."; exit; fi
  
hammer -u admin host delete --name ${name}.hahsnejeb.co.uk


puppet cert revoke ${name}.hahsnejeb.co.uk
puppet cert clean ${name}.hahsnejeb.co.uk

sed -i "/$name/d" /root/.ssh/known_hosts

virsh destroy $name
virsh undefine $name
rm -f /var/lib/libvirt/images/$name.img

curl -s -i -X DELETE http://sensu.hahsnejeb.co.uk:4567/clients/${name}.hahsnejeb.co.uk
