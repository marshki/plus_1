#!/bin/bash 
# Prompt user for input until non-existent username is entered.        

# send ID and standard error to /dev/null

username_check () { 

  while true

  do
    read -r -p "Enter username to add and press [Enter]: " username  

    if id "$username" >/dev/null 2>&1; then
      printf "%s\\n" "ERROR: $username already exists. Try again."
    else 
      printf "%s\\n" "$username does not exist. Continuing..."   
      break
    fi
  
  done
} 

username_check
