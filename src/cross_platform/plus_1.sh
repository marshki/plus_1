#!/usr/bin/env bash
#
# plus_1
#
# Create local user account(s) in:
# GNU/Linux (via useradd) or macOS (via sysadminctl).
#
# Author: M. Krinitz <mjk235 [at] nyu [dot] edu>
# Date: 2024.12.28
# License: MIT

export PATH="/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

LOG_FILE="plus_1.log"

#####################
# Functions in common
#####################

# Write changes/errors w/timestamp to LOG_FILE for tracking.
log() {
  printf "%s\n" "$(date +"%b %d %X") $*" |tee -a "$LOG_FILE"
}

# Check if the script is run with root privileges. If not, exit.
root_check() {
  if [ "$EUID" -ne "0" ]; then
    log "ERROR: Root privileges required to continue. Exiting." >&2
    exit 1
fi
}

# Prompt for the username and ensure it does not exist.
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

# Prompt fot the 'Real' username.
get_realname() {
  read -r -p "Enter 'real' name to add and press [Enter]: " realname
}

# Prompt for the password and confirm it.
get_password() {
  while true; do
    read -r -s -p "Enter password to add and press [Enter]: " pass1
    printf "\n"
    read -r -s -p "Re-enter password to add and press [Enter]: " pass2
    printf "\n"
    if [[ "$pass1" != "$pass2" ]]; then
      log "ERROR: Passwords do no match."
    else
      printf "%s\n" "Passwords match. Continuing..."
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

#####################
# GNU/Linux functions 
#####################

# Create account in GNU/Linux via useradd using input from user_info.
create_user_linux() {
  printf "%s\n" "Adding user..."
  if useradd --create-home --user-group --home /home/"$username" \
    --comment "$realname" --shell /bin/bash "$username"; then
    log "New user created: name='$username', home=/home/'$username', shell=/bin/bash."
  else
    log "Error: Failed to create user $username"
    exit 1
  fi
}

# Set password for new user.
set_password_linux() {
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
    read -r -p \
      "Add default directory structure (desktop users generally want this) [yes/no]? " prompt
    if [[ "$prompt" = "yes" ]]; then
      printf "%s\n" "Creating default directories..."
      if su "${username}" -c xdg-user-dirs-update; then
        log "Default directory structure created for $username."
      else
        log "ERROR: Failed to create default directory structure for $username."
        exit 1
      fi
    fi
  else
    log "xdg-user-dirs-update command not available. Skipping default directory creation."
  fi
}

# Add the user to the sudo or wheel group if desired.
add_admin_user() {
  read -r -p "Add user to administrator (sudo/wheel) group [yes/no]? " prompt
  if [[ "$prompt" == "yes" ]]; then
    printf "%s\n" "Checking for administrator group..."
    if getent group sudo >/dev/null; then
      if usermod --append --groups sudo "$username"; then
        log "User $username added to sudo group."
      else
        log "ERROR: Failed to add user $username to sudo group."
        exit 1
      fi
    elif getent group wheel >/dev/null; then
      if usermod --append --groups wheel "$username"; then
        log "User $username added to wheel group."
      else
        log "ERROR: Failed to add user $username to wheel group."
        exit 1
      fi
    else
      log "ERROR: No admin group found. Exiting." >&2
      exit 1
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

#################
# macOS functions
#################

# Get highest current UID and increment +1.
get_uid() {
  uid=$(dscl . -list /Users UniqueID | sort --numeric-sort --key=2 | \
    awk 'END{print $2}')
  increment_uid=$((uid + 1))
}

# Primary group ID prompt.
get_primarygroup() {
  printf "%s\n" "Primary Group ID: 80=admin, 20=standard"
  while true; do
    read -rp "Enter primary group ID to add and press [Enter]: " primarygroup
    if [[ "$primarygroup" =~ ^(20|80)$ ]]; then
      break
    else
      log "ERROR: Invalid group ID. Try again."
    fi
  done
}

# Password hint prompt.
get_hint() {
  read -rp "Enter password hint to add and press [Enter]: " passhint
}

# Create account via sysadminctl using input from user_info.
create_user_macOS() {
  printf "%s\n" "Adding user..."
  sysadminctl -addUser "$username" \
              -UID "$increment_uid" \
	      -fullName "$realname" \
              -password "$pass2" \
              -passwordHint "$passhint" \
              -shell /bin/bash \
	      -GID "$primarygroup"
  log "New user created: name='$username', home=/Users/'$username', shell=/bin/bash"
}

# macOS wrapper.
add_macOS() {
  get_uid
  get_hint
  get_primarygroup
  create_user_macOS
}

######
# Main 
######

# Exit status check.
exit_status() {
  if [[ $1 -ne 0 ]]; then
    log "ERROR: Something went wrong, homie..."
    printf "%s\n" "Error: User account creation failed."
  else
    log "Done."
    printf "%s\n" "User account created successfully."
  fi
}

# Detect system architecture, then act.
plus_1() {
    case $(uname -s) in
    Darwin)
      add_macOS
      ;;
    Linux)
      add_linux
      ;;
    *)
      printf "%s\n" "You got the wrong one, homie"
      ;;
    esac
}

main() {
  root_check
  printf "%s\n" "plus_1: A Bash script to create local user accounts in GNU/Linux & macOS."
  while true; do
    read -r -p "Create user account? (yes/no): " answer
    if [ "$answer" = yes ]; then
      printf "%s\n" "Let's add a user..."
      user_info
      plus_1
      retVal=$?
      exit_status $retVal
    else
      printf "%s\n" "Exiting."
      exit 0
    fi
  done
}

main "$@"
