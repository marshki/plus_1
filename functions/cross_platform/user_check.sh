#!/usr/bin/env bash
#
# Exit if username exists.

name='someuser'

# Check if id exists. Send id and standard error to /dev/null.
username_check() {
  if id "$name" >/dev/null 2>&1; then
    printf "%s\n" "ERROR: $name already exists. Exiting." >&2
    exit 1
  fi
}

username_check
