#!/usr/bin/env bash
# Create default user directories, e.g. Desktop, Music, etc.
# For reference: 
# https://wiki.archlinux.org/index.php/XDG_user_directories

username='sjobs'

create_default_dirs() {
 
  if [[ -n $(command -v xdg-user-dirs-update) ]]; then
    su ${username} -c xdg-user-dirs-update
  # To use sudo instead of su, do:
  # read -s -p "Enter sudo password: " passy
  #
  # printf "%s" "$passy" |sudo -u $username -i xdg-user-dirs-update
  fi
}

create_default_dirs
