#!/usr/bin/env bash
# An impefect way to check if $destination is available.
# Note: ping must be run as 'root'

timestamp="$(date +'%b %d %Y %X')"

subject="Site Reliability Engineering"
from=""
to=""

destination=""

mail_cmd="sendmail -f $from -t $to"

#retVal=$?

ping_destination() {

  printf "%s\n" "Pinging $destination..."

  ping -c1 -W1 -q $destination &>/dev/null;
  
  retVal=$?

  if [[ $retVal != 0 ]]; then
  {
    printf "Subject:%s\n" "$subject"
    printf "%s\n" "$destination not found - $(date) - Exiting."
  } | $mail_cmd

  exit 1
fi
}

ping_destination
