#!/bin/bash 
# Exit if username exists.         

# send ID and standard error to /dev/null

#name='lilmac'



while true

read -r -p "Enter username: " name

do
   if id "$name" >/dev/null 2>&1;then
      printf "%s\\n" "ERROR: $name already exists. Try again."
   else 
      printf "%s\\n" "$name does not exist. Continuing."   
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
