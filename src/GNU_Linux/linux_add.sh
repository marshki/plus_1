#!/usr/bin/env bash
# Create local user account(s) in GNU/Linux
# via `user add` utility. 

LOG_FILE="linux_add.log"

#####
# LOG
#####

# Write changes/errors w/timestamp to LOG_FILE for tracking

log () {
  printf "%s\n" "$(date +"%b %d %X :") $*" |tee -a "$LOG_FILE"
}

##############
# linux_add.sh
##############

# Is current UID 0? If not, exit.
 
root_check () {
  if [ "$EUID" != "0" ] ; then
    log "ERROR: Root privileges required to continue. Exiting." >&2 

    exit 1 
fi
}

# Username prompt w/check.

get_username () { 
  while true

  read -r -p "Enter username to add and press [Enter]: " username

  do
    if id "$username" >/dev/null 2>&1;then
      log "ERROR: $username already exists. Try again."
    else
      printf "%s\n" "$username does not exist. Continuing..."
      break
    fi
  
  done
}

# Real name prompt. 

get_realname() {
  read -r -p "Enter 'real name' to add and press [Enter]: " realname
}

get_password () {
  while true
  do

    read -r -s -p "Enter password to add and press [Enter]: " pass1
    printf "\\n"
    read -r -s -p "Re-enter password to add and press [Enter]: " pass2
    printf "\\n"

    if [[ "$pass1" != "$pass2" ]]; then
      log "ERROR: Passwords do no match."
    else
      printf "%s\n" "Passwords match. Continuing..."
      break
    fi
  done
}

# Wrapper

user_info() {
  get_username
  get_realname
  get_password
}

# Create account via useradd using input from user_info.

create_user() {
  printf "%s\n" "Adding user..."

  #log useradd --create-home --user-group --home /home/"$username" --comment "$realname" --shell /bin/bash "$username"
  log "$(useradd --create-home --user-group --home /home/"$username" --comment "$realname" --shell /bin/bash "$username")"
}

# OK, here's the deal: the command itself is not verbose,
# and I don't see a way to up the volume. 
# printf with some version of the same should be enough

#linux_add.log 
#Jan 30 17:10:28 : ERROR: Root privileges required to continue. Exiting.
#Jan 30 17:17:38 : 
#Jan 30 17:17:41 : su sjobs -c xdg-user-dirs-update

# /var/log/authlog
#Jan 30 17:17:37 pywype useradd[1120]: new group: name=sjobs, GID=1003
#Jan 30 17:17:37 pywype useradd[1120]: new user: name=sjobs, UID=1003, GID=1003, home=/home/sjobs, shell=/bin/bash
#Jan 30 17:17:38 pywype chpasswd[1130]: pam_unix(chpasswd:chauthtok): password changed for sjobs

# Set password.

set_password() {
  printf "%s\n" "Setting password..." 

  printf "%s" "$username:$pass2" | chpasswd 
}

# Create default directories.

create_default_dirs () {
  read -r -p "Add default directory structure (desktop users generally want this) [yes/no]? " PROMPT

  if [[ "$PROMPT" = "yes" ]] && [[ -n $(command -v xdg-user-dirs-update) ]]
  then
    printf "%s\n" "Creating default directories..."

    log su "${username}" -c xdg-user-dirs-update
  fi
}

# Add user to admin group. 

add_admin_user () {

  read -r -p "Add user to administrator (sudo/wheel) group [yes/no]? " PROMPT

  if [[ "$PROMPT" = "yes" ]]
  then
    printf "%s\n" "Checking for administrator group..."
    
    if [ "$(getent group sudo)" ]
    then
        printf "%s\n" "Adding user to sudo group..."
        log usermod --append --groups sudo "$username"

    elif [ "$(getent group wheel)" ]
    then
        printf "%s\n" "Adding user to wheel group..."
        log usermod --append --groups wheel "$username"

    else
        if ! [ "$(getent group sudo)" ] && ! [ "$(getent group wheel)" ]
        then
            log "ERROR: No admin group found. Exiting." >&2
            exit 1
        fi
    fi
  fi
}

# plus_1/account creation wrapper.

create_account () {
  user_info
  create_user
  set_password
  create_default_dirs
  add_admin_user
}
 
# Exit status check.

exit_status () {
  if [[ $retVal -ne 0 ]]; then
    log "Something went wrong, homie..."
  else
    printf "%s\n" "Done."
  fi
}

main () {
  root_check

  printf "%s\n" "plus_1: A Bash script to create local user accounts in GNU/Linux."

  while true
  do
    read -r -p "Create user account? (yes/no): " answer

    if [ "$answer" = yes ]; then
      printf "%s\n" "Let's add a user..."
      create_account
    else
      printf "%s\n" "Exiting."
      exit 0
    fi
  done
}

main "$@"

retVal=$?
log exit_status
