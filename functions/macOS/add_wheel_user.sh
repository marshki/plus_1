#!/use/bin/env bash
# Check OS for wheel group via `dseditgroup`,
# then, using `dseditgroup `, add user to group.
# wheel = root

username='sjobs'

add_admin_user() {
  read -r -p "Add user to wheel group [yes/no]? " PROMPT

  if [[ "$PROMPT" = "yes" ]]; then
    printf "%s\n" "Checking for wheel group."

    if [ "$(dseditgroup -o read wheel 2>/dev/null)" ]; then
      printf "%s\n" "Adding user to wheel group..."
      dseditgroup -o edit -a username -t "$username" wheel

    else
      if ! [ "$(dseditgroup -o read wheel 2>/dev/null)" ]; then
        printf "%s\n" "ERROR: No wheel group found. Exiting." >&2
          exit 1
      fi
    fi
  fi
}

add_admin_user
