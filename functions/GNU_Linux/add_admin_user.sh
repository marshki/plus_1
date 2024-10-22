#!/use/bin/env bash
#
# Grant user administrator privileges.
username='sjobs'

# Export binary paths.
export PATH="/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

# Check OS for administrative group via `getent`,
# then, using `usermod`, add user to group.
# sudo = Debian-based
# wheel = RHEL-based
add_admin_user() {
  read -r -p "Add user to administrator (sudo/wheel) group [yes/no]? " prompt
    if [[ "$prompt" == "yes" ]]; then
      printf "%s\n" "Checking for administrator group..."
      if getent group sudo >/dev/null; then
          if usermod --append --groups sudo "$username"; then
              printf "%s\n" "User $username added to sudo group"
          else
              printf "%s\n" "ERROR: Failed to add user $username to sudo group"
          fi
      elif getent group wheel >/dev/null; then
          if usermod --append --groups wheel "$username"; then
              printf "%s\n" "User $username added to wheel group"
          else
              printf "%s\n" "ERROR: Failed to add user $username to wheel group"
          fi
      else
          printf "%s\n" "ERROR: No admin group found. Exiting." >&2
          exit 1
      fi
  fi
}

add_admin_user
