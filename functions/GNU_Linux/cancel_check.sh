#!/usr/bin/env bash
# Check the exit status of whiptail commands.

cancel_check() {
  if [[ $? -ne 0 ]]; then
    whiptail --title "$program" --msgbox "Operation cancelled. Exiting." 8 40
    exit 1
  fi
}

cancel_check
