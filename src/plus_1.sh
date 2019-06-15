#!/bin/bash 
# mjk235 [at] nyu [dot] edu --2019.06.03

#=======================================
# Create local user account in 
# GNU/Linux or macOS 
#=======================================

#=======================================
# Arrays for: user prompt, variables
#=======================================

PROMPT=("user name" "'real' name" "password" "Re-enter password" "primary group ID")

ASSIGN=(username realname pass1 pass2 primarygroup) 

#=======================================
# Functions in common 
#=======================================

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

# Wrapper function 

user_info() { 
  get_username 
  username_check 
  get_realname 
  get_password
  confirm_password 
  check_password
} 

#=======================================
# GNU/Linux Functions 
#=======================================

# Create account in GNU/Linux via useradd using input from user_info 

create_user_linux() { 
  printf "%s\\n" "Adding user..." 

  useradd --create-home --user-group --home /home/"$username" --comment "$realname" --shell /bin/bash "$username" 
} 

set_password_linux() { 
  printf "%s\\n" "Setting password..." 

  printf "%s" "$username:$pass2" | chpasswd 
}

add_linux() {
  create_user_linux
  set_password_linux
} 

#=======================================
# macOS Functions 
#=======================================

# Get highest current UID and increment +1 

get_uid () { 
  uid=$(dscl . -list /Users UniqueID |sort --numeric-sort --key=2 |awk 'END{print $2}')
  increment_uid=$((uid +1))
} 

# Primary group ID prompt. 

get_primarygroup() { 
  printf "%s\n" "Primary Group ID: 80=admin, 20=standard" 
  read -rp "Enter ${PROMPT[2]} to add and press [Enter]: " ${ASSIGN[2]}
} 

# Create account in macOS via dscl using input from user_info 

create_user_macOS() { 
  printf "%s\\n" "Adding user..." 

  dscl . -create /Users/"$username"
  dscl . -create /Users/"$username" UniqueID "$increment_uid" 
  dscl . -create /Users/"$username" UserShell /bin/bash
  dscl . -create /Users/"$username" RealName "$realname"
  dscl . -create /Users/"$username" PrimaryGroupID "$primarygroup"
  dscl . -create /Users/"$username" NFSHomeDirectory /Users/$username
  dscl . -passwd /Users/"$username" "$pass2"
} 


# Create home directory macOS 

create_homedir(){ 
  createhomedir -u $username -c 
} 

add_macOS(){ 
  get_uid
  get_primarygroup
  create_user_macOS
  create_homedir
} 

#=======================================
#  
#=======================================

# detect system architecture, then act
  
os_check () { 

    case $(uname -s) in
    Darwin)
      add_macOS 
      ;;
    Linux)
      add_linux  
      ;;
    *)
      printf "%s\\n" "He can't handle your speed, $(uname -s)"
      ;;
    esac 
} 

main () { 
  root_check
  user_info
  os_check
}

main "$@" 
