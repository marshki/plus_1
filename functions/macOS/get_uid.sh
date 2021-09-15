#!/usr/bin/env bash
# Get the highest UID and increment +1.

# sort numerically by second field
# pipe to awk to print last record from second field
# increment +1

get_uid (){

  uid=$(dscl . -list /Users UniqueID |sort --numeric-sort --key=2 |awk 'END{print $2}')
  printf "%s\n" "Highest UID: $uid"

  increment_uid=$((uid +1))
  printf "%s\n" "Next UID: $increment_uid"
}

get_uid
