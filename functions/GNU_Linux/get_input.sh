#!/bin/bash 
# Get user input   

# Associative array for user prompts.  
# Strictly speaking, the array is not needed.
# It's here as a test for the larger program.


PROMPT=(
"user name"
"'real' name"
"password"
)

# Associative array for variable assignments. 

ASSIGN=(
username
realname
pass1
)

# read -r (esc. key binding) & present prompt  
# assign user input to variable 

get_username() { 
  read -rp "Enter ${PROMPT[0]} to add and press [Enter]: " "${ASSIGN[0]}" 

  printf "%s\n" "$username"
} 

get_realname() { 
  read -rp "Enter ${PROMPT[1]} to add and press [Enter]: " "${ASSIGN[1]}"

  printf "%s\n" "$realname"
} 

get_pass() {
  read -rp "Enter ${PROMPT[2]} to add and press [Enter]: " "${ASSIGN[2]}"

  printf "%s\n" "$pass1"

} 

get_input(){ 
  get_username
  get_realname
  get_pass
} 

get_input

#read -rp "Enter user name to add and press [Enter]: " username
#printf "%s\n" "$username"
#read -rp "Enter 'real' name to add and press [Enter]: " realname
#printf "%s\n" "$realname"
#read -rp "Enter password to add and press [Enter]: " pass1
#printf "%s\n" "$pass1"
