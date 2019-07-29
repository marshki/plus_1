#!/bin/bash 
# Create local user account in macOS w/directory in /Users
# via dscl utility.

# Is current UID 0? If not, exit. (Not needed for non-admin account creation).

root_check () {
  if [ "$EUID" -ne "0" ] ; then
    printf "%s\\n" "ERROR: Root privileges required to continue. Exiting." >&2
    exit 1
fi
}

# Username prompt. 

get_username () { 
  while true

  read -r -p "Enter username to add and press [Enter]: " username 

  do 
    if id "$username" >/dev/null 2>&1;then
      printf "%s\\n" "ERROR: $username already exists. Try again."
    else 
      printf "%s\\n" "$username does not exist. Continuing..."   
      break
    fi
  
  done
}

# Get highest current UID and increment +1 

get_uid () { 
  uid=$(dscl . -list /Users UniqueID |sort --numeric-sort --key=2 |awk 'END{print $2}')
  increment_uid=$((uid +1))
} 

# Real name prompt. 

get_realname() { 
  read -rp "Enter 'real name' to add and press [Enter]: " realname 
} 

# Primary group ID prompt. 

get_primarygroup() { 
  printf "%s\n" "Primary Group ID: 80=admin, 20=standard" 
  read -rp "Enter primary group ID to add and press [Enter]: " primarygroup
} 

# Password hint prompt. 

get_hint() { 
  read -rp "Enter password hint to add and press [Enter]: " passhint
}

# Password prompt. 

get_password() { 
  read -r -s -p "Enter password to add and press [Enter]: " pass1
  printf "\\n"   
} 

# Confirm password prompt. 

confirm_password() { 
  read -r -s -p "Re-enter password to add and press [Enter]: " pass2 
  printf "\\n"
} 

# Check if passwords match. Exit if not. 

check_password() { 
  if [[ "$pass1" == "$pass2" ]]; then 
    printf "%s\\n" "Passwords match."
  else 
    printf "%s\\n" "ERROR: Passwords do not match. Exiting."
    exit 1
  fi 
} 

# Wrapper. 

user_info(){ 
  get_username 
  get_realname
  get_primarygroup
  get_hint
  get_password
  confirm_password
  check_password
} 

# Create account via dscl using input from user_info 

create_user() { 
  printf "%s\\n" "Adding user..." 

  dscl . -create /Users/"$username"
  dscl . -create /Users/"$username" UniqueID "$increment_uid" 
  dscl . -create /Users/"$username" UserShell /bin/bash
  dscl . -create /Users/"$username" RealName "$realname"
  dscl . -create /Users/"$username" PrimaryGroupID "$primarygroup"
  dscl . -create /Users/"$username" NFSHomeDirectory /Users/"$username"
  dscl . -create /Users/"$username" hint "$passhint"
  dscl . -passwd /Users/"$username" "$pass2"
} 

# Create home directory  

create_homedir(){ 
  createhomedir -u "$username" -c 
} 

# Exit status check.

exit_status () { 
  if [[ $retVal -ne 0 ]]; then
    printf "%s\\n" "Something went wrong, homie."
  else
    printf "%s\\n" "Done."
  fi
}  

# Wrapper function. 

create_account(){ 
  create_user 
  create_homedir
} 

main () {
  root_check 
  user_info
  create_account  
}

main "$@"

retVal=$?
exit_status
