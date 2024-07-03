#!/usr/bin/env bash
# sysadminctl implementation of create_user.sh located in this directory.
# WILL create a /Users directory.

# For example (test this first!): sysadminctl -addUser username -fullName "User Name" -UID 1001 -shell /bin/bash -password password

create_user() {
  printf "%s\n" "Adding user..."

  sysadminctl -addUser "$username" \
              -fullName "$realname" \
              -UID "$increment_uid" \
              -shell /bin/bash \
              -password "$pass2" \
              -home /Users/"$username"

  log "New user created: name='$username', home=/Users/'$username', shell=/bin/bash"
}

