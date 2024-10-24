#!/usr/bin/env bash
#
# Delete user account in GNU/Linux.

# Export binary paths.
export PATH="/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

username='tcook'

delete_user () {
  printf "%s\n" "Deleting user..." 
  deluser --remove-home $username
  # alternative:
  # userdel --remove --force $username  
}

delete_user
