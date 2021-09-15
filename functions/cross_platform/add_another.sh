#!/usr/bin/env bash

while true 

do 

  read -r -p "Add another user? (yes/no): " answer 

  if [ "$answer" = yes ]; then 
    printf "%s\n" "Adding another user..."

  else 
    printf "%s\n" "Exiting program..."
    exit 0 
  fi 

done

