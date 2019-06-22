#!/bin/bash 
# Create home directory for user in /Users. 

username="sjobs"

create_homedir(){ 
  createhomedir -u $username -c 
} 

create_homedir
