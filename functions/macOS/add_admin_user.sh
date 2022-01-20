#!/use/bin/env bash

# Option 1: 
# Check OS for administrative group via `dscl`: 
# dscl . read /Groups/admin

# Option 2 (probably preferable, but need to test): 
# Check OS for administrative group via `dsedit`:
# dseditgroup -o read admin

# then, using `dseditgroup `, add user to group:
# dseditgroup -o edit -a username -t user admin

username='sjobs'

add_admin_user () {

  read -r -p "Add user to admin group [yes/no]? " PROMPT

  if [[ "$PROMPT" = "yes" ]]
  then 
    printf "%s\n" "Checking for admin group."
    
    if [ "$(dscl . read /Groups/poop)" ]
    then
        printf "%s\n" "Adding user to admin group..."
        #dseditgroup -o edit -a username -t "$username" admin

    else
        if ! [ "$(dscl . read /Groups/poop)" ]
        then
            printf "%s\n" "ERROR: No admin group found. Exiting." >&2
            exit 1
        fi
    fi
  fi
}

add_admin_user
