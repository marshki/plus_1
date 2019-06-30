#!/bin/bash
# Create user directories, e.g. Desktop, Music, etc.

# For reference: https://wiki.archlinux.org/index.php/XDG_user_directories

if [[ ! -z $(which xdg-user-dirs-update) ]]
then
  su - ${username} -c "xdg-user-dirs-update"
  ### if you want to use sudo instead of su:
  # sudo -u ${username} -i xdg-user-dirs-update
fi
