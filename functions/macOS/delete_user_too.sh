#!/usr/bin/env bash
# Delete user account in macOS.

username='sjobs'

delete_user() {
  printf "%s\n" "Deleting user..."

  sysadminctl -deleteUser "$sjobs"  
}
