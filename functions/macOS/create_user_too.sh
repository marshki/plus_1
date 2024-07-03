#!/usr/bin/env bash
# sysadminctl implementation of create_user.sh located in this directory.
# Add user WITH creating a /Users directory.

username='sjobs'
increment_uid='502'
realname='Steve Jobs'
primarygroup='20'
passhint='1...'
pass2='1morething'

create_user() {
  printf "%s\n" "Adding user..."

  sysadminctl -addUser "$username" \
              -fullName "$realname" \
              -UID "$increment_uid" \
              -shell /bin/bash \
              -password "$pass2" \
              -home /Users/"$username" \
              -passwordHint "$passhint" \
              -primaryGroupID "$primarygroup"

  # log "New user created: name='$username', home=/Users/'$username', shell=/bin/bash, primary group ID='$primarygroup'"
}

create_user
