#!/usr/bin/env bash
#
# plus_1
# 
# User account creation via `useradd` utility (GNU/Linux).
#
# Author: M. Krinitz <mjk235 [at] nyu [dot] edu>
# Date: 2024.09.25
# License: MIT

LOG_FILE="plus_1.log"

# Write changes/errors with a timestamp to LOG_FILE for tracking.
log() {
  printf "%s\n" "$(date +"%b %d %X") $*" | tee -a "$LOG_FILE"
}

# Check if the script is run with root privileges. If not, exit.
root_check() {
  if [ "$EUID" -ne 0 ]; then
    log "ERROR: Root privileges required to continue. Exiting." >&2
    exit 1
  fi
}

# Username prompt with check.
get_username() {
  while true; do
    username=$(whiptail --inputbox "Enter username to add:" 8 39 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus -ne 0 ]; then
      log "User canceled the operation."
      exit 1
    fi
    if id "$username" >/dev/null 2>&1; then
      whiptail --msgbox "ERROR: $username already exists. Try again." 8 39
      log "ERROR: $username already exists. Try again."
    else
      whiptail --msgbox "$username does not exist. Continuing..." 8 39
      break
    fi
  done
}

# 'Real' name prompt.
get_realname() {
  realname=$(whiptail --inputbox "Enter 'real name' to add:" 8 39 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ $exitstatus -ne 0 ]; then
    log "User canceled the operation."
    exit 1
  fi
}

# Password prompt.
get_password() {
  while true; do
    pass1=$(whiptail --passwordbox "Enter password to add:" 8 39 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus -ne 0 ]; then
      log "User canceled the operation."
      exit 1
    fi
    pass2=$(whiptail --passwordbox "Re-enter password to add:" 8 39 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus -ne 0 ]; then
      log "User canceled the operation."
      exit 1
    fi
    if [[ "$pass1" != "$pass2" ]]; then
      whiptail --msgbox "ERROR: Passwords do not match." 8 39
      log "ERROR: Passwords do not match."
    else
      whiptail --msgbox "Passwords match. Continuing..." 8 39
      break
    fi
  done
}

# Wrapper function to gather user information.
user_info() {
  get_username
  get_realname
  get_password
}

# Create a user account using useradd with the gathered information.
create_user() {
  printf "%s\n" "Adding user..."
  if useradd --create-home --user-group --home "/home/$username" \
             --comment "$realname" --shell /bin/bash "$username"; then
    log "New user created: name='$username', home=/home/'$username', shell=/bin/bash"
  else
    log "ERROR: Failed to create user $username"
    exit 1
  fi
}

# Set the password for the new user.
set_password() {
  printf "%s\n" "Setting password..."
  if printf "%s" "$username:$pass2" | chpasswd; then
    log "Password set for user $username"
  else
    log "ERROR: Failed to set password for user $username"
    exit 1
  fi
}

# Create default directories if xdg-user-dirs-update is available.
create_default_dirs() {
  if command -v xdg-user-dirs-update >/dev/null; then
    prompt=$(whiptail --yesno "Add default directory structure (desktop users generally want this)?" 8 39 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus -ne 0 ]; then
      log "User canceled the operation."
      exit 1
    fi
    if [ "$prompt" = "yes" ]; then
      printf "%s\n" "Creating default directories..."
      if su "${username}" -c xdg-user-dirs-update; then
        log "Default directory structure created for $username"
      else
        log "ERROR: Failed to create default directory structure for $username"
        exit 1
      fi
    fi
  else
    log "xdg-user-dirs-update command not available. Skipping default directory creation."
  fi
}

# Add the user to the sudo or wheel group if desired.
add_admin_user() {
  prompt=$(whiptail --yesno "Add user to administrator (sudo/wheel) group?" 8 39 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ $exitstatus -ne 0 ]; then
    log "User canceled the operation."
    exit 1
  fi
  if [[ "$prompt" == "yes" ]]; then
    printf "%s\n" "Checking for administrator group..."
    if getent group sudo >/dev/null; then
      if usermod --append --groups sudo "$username"; then
        log "User $username added to sudo group"
      else
        log "ERROR: Failed to add user $username to sudo group"
        exit 1
      fi
    elif getent group wheel >/dev/null; then
      if usermod --append --groups wheel "$username"; then
        log "User $username added to wheel group"
      else
        log "ERROR: Failed to add user $username to wheel group"
        exit 1
      fi
    else
      log "ERROR: No admin group found. Exiting." >&2
      exit 1
    fi
  fi
}

# Wrapper function to create the account.
create_account() {
  user_info
  create_user
  set_password
  create_default_dirs
  add_admin_user
}

# Exit status check.
exit_status() {
  if [[ $1 -ne 0 ]]; then
    log "ERROR: Something went wrong, homie..."
  else
    log "Done."
  fi
}

# Main function.
main() {
  root_check
  whiptail --msgbox "plus_1: A Bash script to create local user accounts in GNU/Linux." 8 39
  while true; do
    answer=$(whiptail --yesno "Create new user account?" 8 39 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus -ne 0 ]; then
      log "User canceled the operation."
      exit 1
    fi
    if [ "$answer" = yes ]; then
      printf "%s\n" "Let's add a user..."
      create_account
      retVal=$?
      exit_status $retVal
    else
      whiptail --msgbox "Exiting." 8 39
      exit 0
    fi
  done
}

main "$@"
