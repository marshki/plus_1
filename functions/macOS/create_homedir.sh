#!/usr/bin/env bash
# Create home directory for user in /Users.
# Use in conjunction with: 'create_user' function in this directory. 

username="sjobs"

create_homedir(){
  createhomedir -u $username -c
}

create_homedir
