#!/usr/bin/env bash
# Add user via useradd utility.

username='sjobs'
realname='Steve Jobs'

create_user() {
  printf "%s\\n" "Adding user..."
  useradd --create-home --user-group --home /home/"$username" --comment "$realname" --shell /bin/bash "$username"
}

create_user
