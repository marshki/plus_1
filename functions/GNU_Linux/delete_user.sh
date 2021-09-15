#!/usr/bin/env bash
# Delete user account in GNU/Linux.

username='sjobs'

delete_user () {
  printf "%s\n" "Deleting user..." 
 
  userdel --remove --force $username  
} 
