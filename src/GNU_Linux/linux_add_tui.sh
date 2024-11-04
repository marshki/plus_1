#!/usr/bin/env bash
#
# plus_1
#
# TUI-based user account creation via `useradd` utility (GNU/Linux).
#
# Author: M. Krinitz <mjk235 [at] nyu [dot] edu>
# Date: 2024.09.25
# License: MIT
#
program="plus_1"
log_file="plus_1.log"

export PATH="/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

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

# Check the 'cancel' status of whiptail.
cancel_check() {
  if [[ $? -ne 0 ]]; then
    whiptail --title "$program" --msgbox "Operation cancelled. Exiting." 8 40
    exit 1
  fi
}

# Username prompt w/check.
get_username() {
  while true; do
    username=$(whiptail --title "$program" --inputbox \
      "Enter username to add and press [Enter]:" 8 40 3>&1 1>&2 2>&3)
    cancel_check
    if id "$username" >/dev/null 2>&1; then
      whiptail --title "$program" --msgbox \
        "ERROR: $username already exists. Try again." 8 40
    else
      whiptail --title "$program" --msgbox \
        "$username does not exist. Continuing..." 8 40
      break
    fi
  done
}

# 'Real' name prompt.
get_realname() {
  realname=$(whiptail --title "$program" --inputbox \
    "Enter 'real name' to add and press [Enter]:" 8 40 3>&1 1>&2 2>&3)
  cancel_check
}

# Password prompt.
get_password() {
  while true; do
    pass1=$(whiptail --title "$program" --passwordbox \
      "Enter password to add and press [Enter]:" 8 40 3>&1 1>&2 2>&3)
    cancel_check
    pass2=$(whiptail --title "$program" --passwordbox \
      "Re-enter password to add and press [Enter]:" 8 40 3>&1 1>&2 2>&3)
    cancel_check
    if [[ "$pass1" != "$pass2" ]]; then
      whiptail --title "$program" --msgbox "ERROR: Passwords do not match." 8 40
    else
      whiptail --title "$program" --msgbox "Passwords match. Continuing..." 8 40
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
  whiptail --title "$program" --msgbox "Adding user..." 8 40
  if useradd --create-home --user-group --home "/home/$username" \
    --comment "$realname" --shell /bin/bash "$username"; then
    log "User created: name='$username', home=/home/'$username', shell=/bin/bash."
  else
    log "ERROR: Failed to create user $username."
    exit 1
  fi
}

# Set password.
set_password() {
  whiptail --title "$program" --msgbox "Setting password..." 8 40
  if printf "%s" "$username:$pass2" | chpasswd; then
    log "Password set for user $username."
  else
    log "ERROR: Failed to set password for user $username."
    exit 1
  fi
}

# Create default directories.
create_default_dirs() {
  whiptail --title "$program" --yesno \
    "Add default directory structure (desktop users generally want this)?" 8 40 \
    3>&1 1>&2 2>&3
  if [[ $? -eq 0 ]] && [[ -n $(command -v xdg-user-dirs-update) ]]; then
    whiptail --title "$program" --msgbox "Creating default directories..." 8 40
    if su "${username}" -c xdg-user-dirs-update; then
      log "Default directory structure created for $username."
    else
      log "ERROR: Failed to create default directory structure for $username."
      exit 1
    fi
  fi
}

# Add user to admin group.
add_admin_user() {
  whiptail --title "$program" --yesno \
    "Add user to administrator (sudo/wheel) group?" 8 40 \
    3>&1 1>&2 2>&3
  if [[ $? -eq 0 ]]; then
    whiptail --title "$program" --msgbox "Checking for administrator group..." 8 40
    if getent group sudo >/dev/null; then
      if usermod --append --groups sudo "$username"; then
        log "User $username added to sudo group."
      else
        log "ERROR: Failed to add user $username to sudo group."
      fi
    elif getent group wheel >/dev/null; then
      if usermod --append --groups wheel "$username"; then
        log "User $username added to wheel group."
      else
        log "ERROR: Failed to add user $username to wheel group."
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
    whiptail --title "$program" --msgbox "ERROR: User account creation failed." 8 40
  else
    log "Done."
    whiptail --title "$program" --msgbox "User account created successfully." 8 40
  fi
}

# Main.
main() {
  root_check
  whiptail --title "$program" --msgbox \
    "plus_1: A Bash script to create local user accounts in GNU/Linux." 8 40
  while true; do
    whiptail --title "$program" --yesno \
      "Create new user account?" 8 40 3>&1 1>&2 2>&3
    if [[ $? -eq 0 ]]; then
      whiptail --title "$program" --msgbox "Let's add a user..." 8 40
      create_account
      retVal=$?
      exit_status $retVal
    else
      whiptail --title "$program" --msgbox "Exiting." 8 40
      exit 0
    fi
  done
}

main "$@"
