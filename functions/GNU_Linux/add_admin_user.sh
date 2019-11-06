#!/bin/bash
# Check OS for administrative group via `getent`,
# then, using `usermod`, add user to group.
# sudo = Debian-based
# wheel = RHEL-based

username='sjobs'

add_admin_user () {

  read -r -p "Add user to administrator (sudo/wheel) group [yes/no]? " PROMPT

  if [[ "$PROMPT" = "yes" ]]
  then 
    printf "%s\\n" "Checking for administrator group."
    
    if [ "$(getent group sudo)" ]
    then
        printf "%s\\n" "Adding user to sudo group..."
        usermod --append --groups sudo "$username"

    elif [ "$(getent group wheel)" ]
    then 
        printf "%s\\n" "Adding user to wheel group..."
        usermod --append --groups wheel "$username"

    else 
        if ! [ "$(getent group sudo)" ] && ! [ "$(getent group wheel)" ]
        then
            printf "%s\\n" "ERROR: No admin group found. Exiting." >&2
            exit 1
        fi
    fi
  fi
}

add_admin_user
