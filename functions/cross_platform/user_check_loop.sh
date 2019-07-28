#!/bin/bash 
# Exit if username exists.         

# send ID and standard error to /dev/null

#name='lilmac'
while true

read -r -p "Enter username to add and press [Enter]: " username 

do 
  if id "$username" >/dev/null 2>&1;then
    printf "%s\\n" "ERROR: $username already exists. Try again."
  else 
    printf "%s\\n" "$username does not exist. Continuing."   
    break
  fi
  
done

#username_check() {

#  if id "$name" >/dev/null 2>&1; then
#    printf "%s\\n" "ERROR: $name already exists. Exiting." >&2 
#    exit 1 
#  fi
#}

#username_check
