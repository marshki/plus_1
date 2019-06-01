#!/bin/bash 
# Create password for user. 

username='sjobs'
passy='1morething'

set_password() { 
  printf "%s\\n" "Setting password..." 

  printf "%s" "$username:$passy" | chpasswd 
} 

set_password
