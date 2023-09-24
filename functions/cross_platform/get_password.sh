#!/usr/bin/env bash
# Password prompt (twice).
# Exit if passwords do not match.

# printf "%s\n" "$pass1" and "$pass2" for illustrative purposes,
# you almost certainly don't want this

# read -r (esc. key binding), -s silently, & -p present prompt  

get_password() {
  read -r -s -p "Enter password to add and press [Enter]: " pass1

  printf "%s\n" "$pass1"
}

confirm_password() {
  read -r -s -p "Re-enter password to add and press [Enter]: " pass2

  printf "%s\n" "$pass2"
}

check_password() { 

  if [[ "$pass1" == "$pass2" ]]; then

    printf "%s\n" "Passwords match."
  else

    printf "%s\n" "ERROR: Passwords do not match. Exiting."
    exit 1
  fi
}

get_password
confirm_password
check_password
