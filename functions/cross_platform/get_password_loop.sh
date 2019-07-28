#!/bin/bash 
# Password prompt (twice). 
# Exit if passwords do not match.

# printf "%s\n" "$pass1" and "$pass2" for illustrative purposes, 
# you almost certainly don't want this

# read -r (esc. key binding), -s silently, & -p present prompt  

while true 
do
  read -r -s -p "Enter password to add and press [Enter]: " pass1 
  read -r -s -p "Re-enter password to add and press [Enter]: " pass2 

  if [[ "$pass1" != "$pass2" ]]; then 
    printf "%s\n" "ERROR: Passwords do no match."
  else 
    printf "%s\n" "Passwords match. Continuing..."
    break
  fi 
done

#get_password
#confirm_password
#check_password
