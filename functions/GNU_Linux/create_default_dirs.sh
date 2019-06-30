#!/bin/bash
# Create user directories, e.g. Desktop, Music, etc.
# https://wiki.archlinux.org/index.php/XDG_user_directories

create_default_dirs () { 
 
  if [[ ! -z $(which xdg-user-dirs-update) ]]
  then
  #su - ${username} -c "xdg-user-dirs-update"
  ### if you want to use sudo instead of su:
  -u ${username} -i xdg-user-dirs-update
  #sudo -u ${username} -i xdg-user-dirs-update
  fi
} 
