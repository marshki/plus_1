#!/bin/bash 
# Create home directory for user. 

username="sjobs"

create_homedir(){ 
  createhomedir -u $username -c 
} 

create_homedir
