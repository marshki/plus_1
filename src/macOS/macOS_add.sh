#!/usr/bin/env bash
#
# macOS_add
#
# Create local user account(s) in macOS w/directory in /Users
# via dscl utility.
#
# Author: M. Krinitz <mjk235 [at] nyu [dot] edu>
# Date: 2023.08.12
# License: MIT

LOG_FILE="macOS_add.log"

# LOG
# Write changes w/ timestamp to LOG_FILE for tracking.

log() {
  printf "%s\n" "$(date +"%b %d %X") $*" | tee -a "$LOG_FILE"
}

# macOS_add

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
  uid=$(dscl . -list /Users UniqueID | sort --numeric-sort --key=2 | awk 'END{print $2}')
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

get_hint() {
  read -rp "Enter password hint to add and press [Enter]: " passhint
}

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

# Check OS for admin group via `dseditgroup`,
# then, using `dseditgroup`, add user to group.

add_admin_user() {
  read -r -p "Add user to admin group [yes/no]? " prompt

  if [[ "${prompt,,}" = "yes" ]]; then
    printf "%s\n" "Checking for admin group."

    if dseditgroup -o read admin 2>/dev/null; then
      printf "%s\n" "Adding user to admin group..."
      dseditgroup -o edit -a "$username" -t user admin
    else
      log "ERROR: No admin group found. Exiting." >&2
      exit 1
    fi
  fi
}

# User info wrapper.

user_info() {
  get_uid
  get_username
  get_realname
  get_primarygroup
  get_hint
  get_password
  add_admin_user
}

# Create account via dscl using input from user_info.

create_user() {
  printf "%s\n" "Adding user..."

  dscl . -create /Users/"$username"
  dscl . -create /Users/"$username" UniqueID "$increment_uid"
  dscl . -create /Users/"$username" UserShell /bin/bash
  dscl . -create /Users/"$username" RealName "$realname"
  dscl . -create /Users/"$username" PrimaryGroupID "$primarygroup"
  dscl . -create /Users/"$username" NFSHomeDirectory /Users/"$username"
  dscl . -create /Users/"$username" hint "$passhint"
  dscl . -passwd /Users/"$username" "$pass2"

  log "new user: name='$username', home=/Users/'$username', shell=/bin/bash"
}

# Create home directory.

create_homedir() {
  createhomedir -u "$username" -c
}

# Create account function.

create_account() {
  user_info
  create_user
  create_homedir
}

# Exit status check.

exit_status() {
  if [[ $1 -ne 0 ]]; then
    log "Something went wrong, homie."
  else
    log "Done."
  fi
}

main() {
  root_check

  printf "%s\n" "plus_1: A Bash script to create local user accounts in macOS."

  while true; do
    read -r -p "Create user account? (yes/no): " answer

    if [[ "${answer,,}" = "yes" ]]; then
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
