#!/bin/bash 
# Should script add default directory structure? Yes/No? 

read -r -p "Add default directory structure (y/n)? " PROMPT

if [ "$PROMPT" = "y" ]; then 
  printf "%s\\n" "Add 'em."; 
else
  printf "%s\\n" "Do not add 'em."; 
fi
 
