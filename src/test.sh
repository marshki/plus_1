#!/bin/bash 
# mjk235 [at] nyu [dot] edu --2019.06.03
# Create local user account in GNU/Linux or macOS 

# Array for user prompts. 

PROMPT=("user name" "'real' name" "password" "Re-enter password")

# Array for variable assignments. 

ASSIGN=(username realname pass1 pass2) 

# Is current UID 0? If not, exit. (Not needed for non-admin account creation).

root_check () {
  if [ "$EUID" -ne "0" ] ; then
    printf "%s\\n" "ERROR: Root privileges required to continue. Exiting." >&2
    exit 1
fi
}

# Username prompt. 

get_username() { 
  read -rp "Enter ${PROMPT[0]} to add and press [Enter]: " "${ASSIGN[0]}" 
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
  read -rp "Enter ${PROMPT[1]} to add and press [Enter]: " "${ASSIGN[1]}"
}

# Password prompt. 

get_password() { 
  read -rp "Enter ${PROMPT[2]} to add and press [Enter]: " "${ASSIGN[2]}" 
} 

# Confirm password prompt. 

confirm_password() { 
  read -rp "${PROMPT[3]} password to add and press [Enter]: " "${ASSIGN[3]}" 
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

set_password() { 
  printf "%s\\n" "Setting password..." 

  printf "%s" "$username:$pass2" | chpasswd 
}

main () { 
  root_check
  user_info
  create_user
  set_password
}

main "$@" 
