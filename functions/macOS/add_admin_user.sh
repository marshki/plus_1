#!/use/bin/env bash
# Check OS for admin group via `dseditgroup`,
# then, using `dseditgroup `, add user to group.
# Acccess session with: sudo -i

username='sjobs'

add_admin_user() {
  read -r -p "Add user to admin group [yes/no]? " prompt

  if [[ "$prompt" = "yes" ]]; then
    printf "%s\n" "Checking for admin group."

    if [ "$(dseditgroup -o read admin 2>/dev/null)" ]; then
      printf "%s\n" "Adding user to admin group..."
      dseditgroup -o edit -a "$username" -t user admin

    else
      printf "%s\n" "ERROR: No admin group found. Exiting." >&2
      exit 1
    fi
  fi
}

add_admin_user
