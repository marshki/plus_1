#!/bin/bash 
# Password prompt (twice). 
# Exit if passwords do not match.

# read -r (esc. key binding) & present prompt  

get_password() { 
  read -rp "Enter password to add and press [Enter]: " pass1 
  printf "%s\n" "$pass1" 
} 

confirm_password() { 
  read -rp "Re-enter password to add and press [Enter]: " pass2 
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
