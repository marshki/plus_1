#!/usr/bin/env bash
# sysadminctl implementation of create_user.sh located in this directory.
# Add user WITH a /Users directory.

username='sjobs'
realname='Steve Jobs'
increment_uid='502'
pass2='1morething'
passhint='1...'
primarygroup='20'
-passwordHint

create_user() {
  printf "%s\n" "Adding user..."

  sysadminctl -addUser "$username" \
              -fullName "$realname" \
              -UID "$increment_uid" \
              -shell /bin/bash \
              -password "$pass2" \
              -passwordHint "$passhint" \
              -GID "$primarygroup"
}

create_user
