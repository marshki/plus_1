#!/bin/bash 
# Create local user account in macOS w/directory in /Users
# via dscl utility 

# Array for user prompts.  

PROMPT=("user name" "'real' name" "primary group ID" "password hint" "password" "Re-enter password")

# Array for variable assignments. 

ASSIGN=(username realname primarygroup passhint pass1 pass2)

# Is current UID 0? If not, exit. (Not needed for non-admin account creation).

root_check () {
  if [ "$EUID" -ne "0" ] ; then
    printf "%s\\n" "ERROR: Root privileges required to continue. Exiting." >&2
    exit 1
fi
}

# Username prompt.  

get_username() { 
  read -rp "Enter ${PROMPT[0]} to add and press [Enter]: " ${ASSIGN[0]} 
} 

# Exit if username exists. 

username_check() {
  if id "$username" >/dev/null 2>&1; then
    printf "%s\\n" "ERROR: $username Already exists. Exiting." >&2 
    exit 1 
  fi 
}

# Get highest current UID and increment +1 

get_uid () { 
  uid=$(dscl . -list /Users UniqueID |sort --numeric-sort --key=2 |awk 'END{print $2}')
  increment_uid=$((uid +1))
} 

# Real name prompt. 

get_realname() { 
  read -rp "Enter ${PROMPT[1]} to add and press [Enter]: " ${ASSIGN[1]}
} 

# Primary group ID prompt. 

get_primarygroup() { 
  printf "%s\n" "Primary Group ID: 80=admin, 20=standard" 
  read -rp "Enter ${PROMPT[2]} to add and press [Enter]: " ${ASSIGN[2]}
} 

# Password hint prompt. 

get_hint() { 
  read -rp "Enter ${PROMPT[3]} to add and press [Enter]: " ${ASSIGN[3]}
}

# Password prompt. 

get_password() { 
  read -rp "Enter ${PROMPT[4]} to add and press [Enter]: " "${ASSIGN[4]}" 
} 

# Confirm password prompt. 

confirm_password() { 
  read -rp "${PROMPT[5]} password to add and press [Enter]: " "${ASSIGN[5]}" 
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
  get_uid
  username_check
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
  dscl . -create /Users/"$username" NFSHomeDirectory /Users/$username
  dscl . -create /Users/"$username" hint "$passhint"
  dscl . -passwd /Users/"$username" "$pass2"
} 

# Create home directory  

create_homedir(){ 
  createhomedir -u $username -c 
} 

# Wrapper. 

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
