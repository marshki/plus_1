#!/usr/bin/env bash
# Get user input.  

# read -r (esc. key binding) & present prompt
# assign user input to variable

get_username() {
  read -r -p "Enter user name to add and press [Enter]: " username

  printf "%s\n" "$username"
}

get_realname() {
  read -r -p "Enter 'real' name to add and press [Enter]: " realname

  printf "%s\n" "$realname"
}

get_pass() {
  read -r -p "Enter password to add and press [Enter]: " pass1

  printf "%s\n" "$pass1"
}

get_input() {
  get_username
  get_realname
  get_pass
}

get_input
