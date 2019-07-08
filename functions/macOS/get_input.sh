#!/bin/bash 
# Get user input   

# Associative array for variable assignments. 

ASSIGN=(
username
realname
primarygroup
passhint
pass1
)

#!/bin/bash
# Get user input

# read -r (esc. key binding) & present prompt
# assign user input to variable

get_username() {
  read -rp "Enter user name to add and press [Enter]: " username
  printf "%s\n" "$username"
}

get_realname() {
  read -rp "Enter 'real' name to add and press [Enter]: " realname
  printf "%s\n" "$realname"
}

get_primarygroup() { 
  read -rp "Enter primary group to add and press [Enter]: " "${ASSIGN[2]}"

  printf "%s\n" "$primarygroup"
} 

get_pass() {
  read -rp "Enter password to add and press [Enter]: " pass1
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



get_hint() { 
  read -rp "Enter ${PROMPT[3]} to add and press [Enter]: " "${ASSIGN[3]}"

  printf "%s\n" "$passhint"
} 

get_input
