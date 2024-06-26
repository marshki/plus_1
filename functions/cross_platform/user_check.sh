#!/usr/bin/env bash
# Exit if username exists.

# Send ID and standard error to /dev/null

name='someuser'

username_check() {
  if id "$name" >/dev/null 2>&1; then

    printf "%s\n" "ERROR: $name already exists. Exiting." >&2
    exit 1
  fi
}

username_check
