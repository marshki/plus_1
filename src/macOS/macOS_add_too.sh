#!/usr/bin/env bash
#
# macOS_add
#
# Create local user account(s) in macOS w/directory in /Users
# via sysadminctl utility.
#
# Author: M. Krinitz <mjk235 [at] nyu [dot] edu>
# Date: 2024.07.09
# License: MIT

LOG_FILE="macOS_add_too.log"

# LOG
# Write changes w/ timestamp to LOG_FILE for tracking.

log() {
  printf "%s\n" "$(date +"%b %d %X") $*" | tee -a "$LOG_FILE"
}

# Is current UID 0? If not, exit.

root_check() {
  if [ "$EUID" -ne 0 ]; then
    log "ERROR: Root privileges required to continue. Exiting." >&2
    exit 1
  fi
}

# Username prompt.
get_username() {
  while true; do
    read -r -p "Enter username to add and press [Enter]: " username
    if id "$username" >/dev/null 2>&1; then
      log "ERROR: $username already exists. Try again."
    else
      printf "%s\n" "$username does not exist. Continuing..."
      break
    fi
  done
}

# Get highest current UID and increment +1.
get_uid() {
  uid=$(getent passwd | awk -F: '{print $3}' | sort -n | tail -1)
  increment_uid=$((uid + 1))
}

# Real name prompt.

get_realname() {
  read -rp "Enter 'real name' to add and press [Enter]: " realname
}

# Primary group ID prompt.

get_primarygroup() {
  printf "%s\n" "Primary Group ID: 80=admin, 20=standard"
  read -rp "Enter primary group ID to add and press [Enter]: " primarygroup
}

# Password hint prompt.
#
#get_hint() {
#  read -rp "Enter password hint to add and press [Enter]: " passhint
#}

# Password prompt.

get_password() {
  while true; do
    read -r -s -p "Enter password to add and press [Enter]: " pass1
    printf "\n"
    read -r -s -p "Re-enter password to add and press [Enter]: " pass2
    printf "\n"
    if [[ "$pass1" != "$pass2" ]]; then
      log "ERROR: Passwords do not match."
    else
      log "Passwords match. Continuing..."
      break
    fi
  done
}

# User info wrapper.
user_info() {
  get_uid
  get_username
  get_realname
  get_primarygroup
  get_hint
  get_password
}

# Create account via sysadminctl using input from user_info.
create_user() {
  printf "%s\n" "Adding user..."
  sysadminctl -addUser "$username" \
              -UID "$increment_uid" \
	      -fullName "$realname" \
              -password "$pass2" \
              #-passwordHint "$passhint" \
	      -home /Users/"$username" \
              -shell /bin/bash \
	      -group "$primarygroup"
  log "New user created: name='$username', home=/Users/'$username', shell=/bin/bash"
}

# Create account function.
create_account() {
  user_info
  create_user
}

# Exit status check.
exit_status() {
  if [[ $1 -ne 0 ]]; then
    log "Something went wrong, homie."

  else
    log "Done."
    printf "%s\n" "User account created successfully."
  fi
}

main() {
  root_check
  printf "%s\n" "plus_1: A Bash script to create local user accounts in macOS."
  while true; do
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
exit_status $retVal
