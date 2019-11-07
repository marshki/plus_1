#!/bin/bash 
# mjk235 [at] nyu [dot] edu --2019.06.03
# Create local user account(s) in: 
# GNU/Linux (via useradd) or macOS (via dscl).  

#=======================================
# Functions in common 
#=======================================

# Is current UID 0? If not, exit.
 
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

# Real name prompt. 

get_realname() { 
  read -r -p "Enter 'real' name to add and press [Enter]: " realname
}

# Password prompt. 

get_password () { 
  while true 
  do
    read -r -s -p "Enter password to add and press [Enter]: " pass1 
    printf "\\n" 
    read -r -s -p "Re-enter password to add and press [Enter]: " pass2 
    printf "\\n" 

    if [[ "$pass1" != "$pass2" ]]; then 
      printf "%s\n" "ERROR: Passwords do no match."
    else 
      printf "%s\n" "Passwords match. Continuing..."
      break
    fi 
  done
} 

# User info wrapper. 

user_info() { 
  get_username 
  get_realname 
  get_password
} 

#=======================================
# GNU/Linux Functions 
#=======================================

# Create account in GNU/Linux via useradd using input from user_info. 

create_user_linux() { 
  printf "%s\\n" "Adding user..." 

  useradd --create-home --user-group --home /home/"$username" --comment "$realname" --shell /bin/bash "$username" 
} 

# Set password. 

set_password_linux() { 
  printf "%s\\n" "Setting password..." 

  printf "%s" "$username:$pass2" | chpasswd 
}

# Create desktop directory structure (option).

create_default_dirs () { 
  read -r -p "Add default directory structure (desktop users generally want this) [yes/no]? " prompt

  if [[ "$prompt" = "yes" ]] && [[ -n $(command -v xdg-user-dirs-update) ]]
  then 
    printf "%s\\n" "Creating default directories..." 

    su "${username}" -c xdg-user-dirs-update 
  fi
}

add_admin_user () {

  read -r -p "Add user to administrator (sudo/wheel) group [yes/no]? " PROMPT

  if [[ "$PROMPT" = "yes" ]]
  then 
    printf "%s\\n" "Checking for administrator group..."
    
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

# GNU/Linux wrapper.

add_linux() {
  create_user_linux
  set_password_linux
  create_default_dirs
  add_admin_user
} 

#=======================================
# macOS Functions 
#=======================================

# Get highest current UID and increment +1.

get_uid () { 
  uid=$(dscl . -list /Users UniqueID |sort --numeric-sort --key=2 |awk 'END{print $2}')
  increment_uid=$((uid +1))
} 

# Primary group ID prompt. 

get_primarygroup() { 
  printf "%s\n" "Primary Group ID: 80=admin, 20=standard" 

  read -rp "Enter primary group ID to add and press [Enter]: " primarygroup
} 

# Create account in macOS via dscl using input from user_info. 

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

# Create home directory macOS. 

create_homedir(){ 
  printf "%s\\n" "Creating home directory..."

  createhomedir -u "$username" -c 
} 

# macOS wrapper.

add_macOS(){ 
  get_uid
  get_primarygroup
  create_user_macOS
  create_homedir
} 

#=======================================
# Main 
#=======================================

# Exit status check. 

exit_status () { 
  if [[ $retVal -ne 0 ]]; then
    printf "%s\\n" "Something went wrong, homie..."
  else
    printf "%s\\n" "Done."
  fi
} 

# Detect system architecture, then act.
  
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

  printf "%s\\n" "plus_1: A Bash script to create local user accounts in GNU/Linux & macOS."

  while true 
  do 
  
    read -r -p "Create user account? (yes/no): " answer

    if [ "$answer" = yes ]; then 
      printf "%s\\n" "Let's add a user..."
      user_info
      plus_1
    else 
      printf "%s\\n" "Exiting."
      exit 0 
    fi 
  done 
}

main "$@" 

retVal=$?
exit_status
