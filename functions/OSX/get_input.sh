#!/bin/bash 
# Get user input   

# Associative array for user prompts.  

PROMPT=(
"user name"
"'real' name"
"primary group ID"
"password hint"
"password"
)

# Associative array for variable assignments. 

ASSIGN=(
username
realname
primarygroup
passhint
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

get_primarygroup() { 
  read -rp "Enter ${PROMPT[2]} to add and press [Enter]: " "${ASSIGN[2]}"

  printf "%s\n" "$primarygroup"
} 

get_hint() { 
  read -rp "Enter ${PROMPT[3]} to add and press [Enter]: " "${ASSIGN[3]}"

  printf "%s\n" "$passhint"
} 

get_pass() {
  read -rp "Enter ${PROMPT[4]} to add and press [Enter]: " "${ASSIGN[4]}"

  printf "%s\n" "$pass1"

} 

get_input(){ 
  get_username
  get_realname
  get_primarygroup
  get_hint
  get_pass
} 

get_input
