#!/usr/bin/env bash
# Prompt user for input (twice) until both inputs match.

# read -r (esc. key binding), -s silently, & -p present prompt
get_password_loop() {
  while true; do
    read -r -s -p "Enter password to add and press [Enter]: " pass1
    printf "\n"
    read -r -s -p "Re-enter password to add and press [Enter]: " pass2
    printf "\n"
    if [[ "$pass1" != "$pass2" ]]; then
      printf "%s\n" "ERROR: Passwords do no match."
    else
      printf "%s\n" "Passwords match. Continuing..."
      break
    fi
  done
}

get_password_loop
