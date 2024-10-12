#!/usr/bin/env bash
#
# plus_1
#
# User account creation via `useradd` utility (GNU/Linux).
# GUI via `whiptail`.
#
# Author: M. Krinitz <mjk235 [at] nyu [dot] edu>
# Date: 2024.09.25
# License: MIT

#script=$(basename "$0")
program="plus_1"
log_file="plus_1.log"

# Write changes/errors w/timestamp to log_file for tracking.
log() {
  printf "%s\n" "$(date +"%b %d %X") $*" | tee -a "$log_file"
}

# Is current UID 0? If not, exit.
root_check() {
  if [ "$EUID" -ne 0 ]; then
    whiptail --title "$program" --msgbox \
      "ERROR: Root privileges required to continue. Exiting." 8 40 3>&1 1>&2 2>&3
    exit 1
  fi
}

# Username prompt w/check.
get_username() {
  while true; do
    username=$(whiptail --title "$program" --inputbox \
      "Enter username to add and press [Enter]:" 8 40 3>&1 1>&2 2>&3)
    if id "$username" >/dev/null 2>&1; then
      whiptail --msgbox "ERROR: $username already exists. Try again." 8 40 --title "Error"
    else
      whiptail --msgbox "$username does not exist. Continuing..." 8 40 --title "Info"
      break
    fi
  done
}

# 'Real' name prompt.
get_realname() {
  realname=$(whiptail --inputbox "Enter 'real name' to add and press [Enter]:" 8 40 --title "Real Name Prompt" 3>&1 1>&2 2>&3)
}

# Password prompt.
get_password() {
  while true; do
    pass1=$(whiptail --passwordbox "Enter password to add and press [Enter]:" 8 40 --title "Password Prompt" 3>&1 1>&2 2>&3)
    pass2=$(whiptail --passwordbox "Re-enter password to add and press [Enter]:" 8 40 --title "Password Prompt" 3>&1 1>&2 2>&3)
    if [[ "$pass1" != "$pass2" ]]; then
      whiptail --msgbox "ERROR: Passwords do not match." 8 40 --title "Error"
    else
      whiptail --msgbox "Passwords match. Continuing..." 8 40 --title "Info"
      break
    fi
  done
}

# Wrapper.
user_info() {
  get_username
  get_realname
  get_password
}

# Create account via useradd using input from user_info.
create_user() {
  whiptail --msgbox "Adding user..." 8 40 --title "Info"
  if useradd --create-home --user-group --home "/home/$username" \
             --comment "$realname" --shell /bin/bash "$username"; then
    log "New user created: name='$username', home=/home/'$username', shell=/bin/bash"
  else
    log "ERROR: Failed to create user $username"
    exit 1
  fi
}

# Set password.
set_password() {
  whiptail --msgbox "Setting password..." 8 40 --title "Info"
  if printf "%s" "$username:$pass2" | chpasswd; then
    log "Password set for user $username"
  else
    log "ERROR: Failed to set password for user $username"
    exit 1
  fi
}

# Create default directories.
create_default_dirs() {
  prompt=$(whiptail --yesno "Add default directory structure (desktop users generally want this)?" 8 40 --title "Default Directories" 3>&1 1>&2 2>&3)
  if [[ $? -eq 0 ]] && [[ -n $(command -v xdg-user-dirs-update) ]]; then
    whiptail --msgbox "Creating default directories..." 8 40 --title "Info"
    if su "${username}" -c xdg-user-dirs-update; then
      log "Default directory structure created for $username"
    else
      log "ERROR: Failed to create default directory structure for $username"
      exit 1
    fi
  fi
}

# Add user to admin group.
add_admin_user() {
  prompt=$(whiptail --yesno "Add user to administrator (sudo/wheel) group?" 8 40 --title "Admin Group" 3>&1 1>&2 2>&3)
  if [[ $? -eq 0 ]]; then
    whiptail --msgbox "Checking for administrator group..." 8 40 --title "Info"
    if getent group sudo >/dev/null; then
      if usermod --append --groups sudo "$username"; then
        log "User $username added to sudo group"
      else
        log "ERROR: Failed to add user $username to sudo group"
      fi
    elif getent group wheel >/dev/null; then
      if usermod --append --groups wheel "$username"; then
        log "User $username added to wheel group"
      else
        log "ERROR: Failed to add user $username to wheel group"
      fi
    else
      log "ERROR: No admin group found. Exiting." >&2
      exit 1
    fi
  fi
}

# plus_1/account creation wrapper.
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
    log "Something went wrong, homie..."
  else
    log "Done."
  fi
}

# Main.
main() {
  root_check
  whiptail --title "$program" --msgbox \
    "plus_1: A Bash script to create local user accounts in GNU/Linux." 8 40   
  while true; do
    answer=$(whiptail --yesno "Create new user account?" 8 40 --title "Create User" 3>&1 1>&2 2>&3)
    if [[ $? -eq 0 ]]; then
      whiptail --msgbox "Let's add a user..." 8 40 --title "Info"
      #create_account
      retVal=$?
      exit_status $retVal
    else
      whiptail --msgbox "Exiting." 8 40 --title "Exit"
      exit 0
    fi
  done
}

main "$@"
