#!/usr/bin/env bash
#
# Add user via useradd utility.

username='sjobs'
realname='Steve Jobs'

# For reference: https://linux.die.net/man/8/useradd
create_user() {
  printf "%s\\n" "Adding user..."
  useradd --create-home --user-group --home /home/"$username" --comment "$realname" --shell /bin/bash "$username"
}

create_user

#create_user() {
#    printf "%s\n" "Adding user..."
#    if useradd --create-home --user-group --home "/home/$username" --comment "$realname" --shell /bin/bash "$username"; then
#        log "New user created: name='$username', home='/home/$username', shell='/bin/bash'"
#    else
#        log "ERROR: Failed to create user $username"
#        exit 1
#    fi
#}
