#!/bin/bash

read -r -p "Add another user? (yes/no): " answer 

while [ "$answer" = yes ]
do

if [ "$answer" = yes ]; then 
  printf "%s\\n" "Adding another user..."
fi
done

printf "%s\\n" "Exiting Program"
exit 0
