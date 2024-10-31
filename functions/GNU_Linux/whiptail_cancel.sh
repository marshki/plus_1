#!/usr/bin/env bash

get_username() {
  while true; do
    username=$(whiptail --title "$program" --inputbox \
      "Enter username to add and press [Enter]:" 8 40 3>&1 1>&2 2>&3)
    
    # Exit if Cancel was pressed
    if [[ $? -ne 0 ]]; then
      whiptail --title "$program" --msgbox "Exiting." 8 40
      exit 0
    fi

    if id "$username" >/dev/null 2>&1; then
      whiptail --title "$program" --msgbox \
        "ERROR: $username already exists. Try again." 8 40
    else
      whiptail --title "$program" --msgbox \
        "$username does not exist. Continuing..." 8 40
      break
    fi
  done
}

get_username
