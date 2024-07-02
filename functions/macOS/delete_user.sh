#!/usr/bin/env bash
# Delete user account in macOS.

username='sjobs'

delete_user() {
  printf "%s\n" "Deleting user..."
  
  dscl . delete /Users/"$username"
  rm -rf /Users/"$username"
}
