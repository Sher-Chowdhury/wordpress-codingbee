#!/bin/bash

useradd ${ssh_guestadmin_username} 
usermod -aG wheel

echo ${ssh_guestadmin_password} | passwd --stdin ${ssh_guestadmin_username} 