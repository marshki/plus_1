#!/bin/bash 
# mjk235 [at] nyu [dot] edu --2019.06.03

#=======================================
# Create local user account in 
# GNU/Linux or macOS 
#=======================================

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
  read -rp "Enter username to add and press [Enter]: " username
} 

# Exit if username exists. 

username_check() {
  if id "$username" >/dev/null 2>&1; then
    printf "%s\\n" "ERROR: $username already exists. Exiting." >&2 
    exit 1 
  fi 
}

# Real name prompt. 

get_realname() { 
  read -rp "Enter realname to add and press [Enter]: " realname
}

# Password prompt. 

get_password() { 
  read -r -s -p "Enter password to add and press [Enter]: " pass1
  printf "%s\\n"
} 

# Confirm password prompt. 

confirm_password() { 
  read -r -s -p "Re-enter password to add and press [Enter]: " pass2 
  printf "%s\\n"
} 

# Check if passwords match. Exit if not. 

check_password() { 
  if [[ "$pass1" == "$pass2" ]]; then 
    printf "%s\\n" "Passwords match. Continuing..."
  else 
    printf "%s\\n" "ERROR: Passwords do not match. Exiting."
    exit 1
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

# Set password 

set_password_linux() { 
  printf "%s\\n" "Setting password..." 

  printf "%s" "$username:$pass2" | chpasswd 
}

# Create desktop directory structure (option)

create_default_dirs () { 
  read -r -p "Add default directory structure (desktop users generally want this) [y/n]? " PROMPT

  if [[ "$PROMPT" = "y" ]] && [[ -n $(command -v xdg-user-dirs-update) ]]
  then 
    printf "%s\\n" "Creating default directories..." 

    su "${username}" -c xdg-user-dirs-update 
  fi
}

# GNU/Linux wrapper

add_linux() {
  create_user_linux
  set_password_linux
  create_default_dirs
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
  read -rp "Enter primary group ID to add and press [Enter]: " primarygroup
} 

# Create account in macOS via dscl using input from user_info 

create_user_macOS() { 
  printf "%s\\n" "Adding user..." 

  dscl . -create /Users/"$username"
  dscl . -create /Users/"$username" UniqueID "$increment_uid" 
  dscl . -create /Users/"$username" UserShell /bin/bash
  dscl . -create /Users/"$username" RealName "$realname"
  dscl . -create /Users/"$username" PrimaryGroupID "$primarygroup"
  dscl . -create /Users/"$username" NFSHomeDirectory /Users/"$username"
  dscl . -passwd /Users/"$username" "$pass2"
} 

# Create home directory macOS 

create_homedir(){ 
  printf "%s\\n" "Creating home directory..."
  createhomedir -u "$username" -c 
} 

# macOS wrapper

add_macOS(){ 
  get_uid
  get_primarygroup
  create_user_macOS
  create_homedir
} 

#=======================================
# Main 
#=======================================

# Detect system architecture, then act
  
plus_1 () { 
    case $(uname -s) in
    Darwin)
      add_macOS 
      ;;
    Linux)
      add_linux  
      ;;
    *)
      printf "%s\\n" "You got the wrong one, homie"
      ;;
    esac 
} 

main () { 
  root_check
  user_info
  plus_1
  printf "%s\\n" "Done." 
}

main "$@" 

retVal=$?
exit_status