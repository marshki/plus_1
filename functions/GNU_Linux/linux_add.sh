#!/bin/bash 
# Create local user account in GNU/Linux 
# via `user add` utility. 

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
  read -r -p "Add default directory structure (desktop users generally want this) [y/n]? " PROMPT

  if [[ "$PROMPT" = "y" ]] && [[ -n $(command -v xdg-user-dirs-update) ]]
  then 
    printf "%s\\n" "Creating default directories..." 

    su "${username}" -c xdg-user-dirs-update 
  fi
}  
 
# Exit status check. 

exit_status () { 
  if [[ $retVal -ne 0 ]]; then
    printf "%s\\n" "Something went wrong, homie..."
  else
    printf "%s\\n" "Done."
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

retVal=$?
exit_status
