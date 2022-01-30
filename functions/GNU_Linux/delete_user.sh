#!/usr/bin/env bash
# Delete user account in GNU/Linux.

username='tcook'

delete_user () {
  printf "%s\n" "Deleting user..." 
  deluser --remove-home $username
  # userdel --remove --force $username  
} 
