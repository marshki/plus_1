#!/usr/bin/env bash
# Is current UID 0? If not, exit.

# Root UID is 0.
# If user's UID is not 0 redirect output to standard error, then exit.

root_check() {
  if [ "$EUID" != "0" ] ; then
    printf "%s\n" "ERROR: Root privileges are required to continue. Exiting." >&2
    exit 1
fi
}

root_check
