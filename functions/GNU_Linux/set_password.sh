#!/usr/bin/env bash
#
# Create password for user.

# Export binary paths.
export PATH="/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

username='sjobs'
passy='1morething'

set_password() {
  printf "%s\\n" "Setting password..."
  printf "%s" "$username:$passy" | $chpasswd
}

set_password
