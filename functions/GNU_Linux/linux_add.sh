#!/bin/bash 
# Create local user account in GNU/Linux 
# via `user add` utility

# Is current UID 0? If not, exit. (Not needed for non-admin account creation).

root_check () {
  if [ "$EUID" -ne "0" ] ; then
    printf "%s\\n" "ERROR: Root privileges required to continue. Exiting." >&2
    exit 1
fi
}

# Username prompt. 

get_username() { 
  read -rp "Enter username to add and press [Enter]: " username 
} 

# Exit if username exists. 

username_check() {
  if id "$username" >/dev/null 2>&1; then
    printf "%s\\n" "ERROR: $username Already exists. Exiting." >&2 
    exit 1 
  fi 
}

# Real name prompt. 

get_realname() { 
  read -rp "Enter 'real name' to add and press [Enter]: " realname
}

# Password prompt. 

get_password() { 
  read -rp "Enter password to add and press [Enter]: " pass1 
} 

# Confirm password prompt. 

confirm_password() { 
  read -rp "Re-enter password to add and press [Enter]: " pass2 
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

# Wrapper 

user_info() { 
  get_username
  get_realname
  get_password
  confirm_password
  check_password
} 

# Create account via useradd using input from user_info 

create_user() { 
  printf "%s\\n" "Adding user..." 

  useradd --create-home --user-group --home /home/"$username" --comment "$realname" --shell /bin/bash "$username" 
} 

# Set password. 

set_password() { 
  printf "%s\\n" "Setting password..." 

  printf "%s" "$username:$pass2" | chpasswd 
}

# Create default directories. 

create_default_dirs () { 
  printf "%s\\n" "Creating default directories..." 
 
  if [[ -n $(command -v xdg-user-dirs-update) ]]
  then
  su ${username} -c xdg-user-dirs-update  
  fi
}  

main () { 
  root_check
  user_info
  create_user
  set_password
  create_default_dirs
}

main "$@" 
