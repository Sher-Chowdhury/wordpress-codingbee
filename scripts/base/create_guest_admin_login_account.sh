#!/bin/bash

useradd ${ssh_guestadmin_username} 
usermod -aG wheel

echo ${ssh_guestadmin_password} | passwd --stdin ${ssh_guestadmin_username} 


sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd
