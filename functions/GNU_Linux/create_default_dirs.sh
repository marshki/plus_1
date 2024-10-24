#!/usr/bin/env bash
#
# Create default user directories, e.g. Desktop, Music, etc.
# in user's /home directory
# For reference:
# https://wiki.archlinux.org/index.php/XDG_user_directories

# Export binary paths.
export PATH="/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

username='sjobs'

create_default_dirs() {
  if [[ -n $(command -v xdg-user-dirs-update) ]]; then
    su ${username} -c xdg-user-dirs-update
  fi
} 
create_default_dirs

# To use sudo instead of su, do:
# read -s -p "Enter sudo password: " passy
#
# printf "%s" "$passy" |sudo -u $username -i xdg-user-dirs-update
