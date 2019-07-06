#!/bin/bash
# Create user directories, e.g. Desktop, Music, etc.
# https://wiki.archlinux.org/index.php/XDG_user_directories

username='sjobs'

create_default_dirs () { 
 
  if [[ -n $(command -v xdg-user-dirs-update) ]]
  then
  su ${username} -c xdg-user-dirs-update  
  ### if you want to use sudo instead of su: ###
  # read -s -p "Enter sudo password: " passy
  # printf "%s" "$passy" |sudo -u $username -i xdg-user-dirs-update
  fi
} 

create_default_dirs
