#!/usr/bin/env bash
#
# Add user via useradd utility.

username='sjobs'
realname='Steve Jobs'

# 'useradd' reference:
# --create-home: create user's home directory
# --user-group: create a group with the same name as the user
# --home: define path of user's home directory
# --comment: users full name or description of account
# --shell: define default login shell
create_user() {
  printf "%s\n" "Adding user..."
  if useradd --create-home --user-group --home "/home/$username" \
             --comment "$realname" --shell /bin/bash "$username"; then
    printf "%s\n" "New user created: name='$username', home='/home/$username', shell='/bin/bash'"
  else
    printf "%s\n" "ERROR: Failed to create user $username"
    exit 1
  fi
}

create_user
