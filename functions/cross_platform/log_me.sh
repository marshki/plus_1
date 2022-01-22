#!/usr/bin/env bash 
# Create log file and write to it when called. 

# You can set a path to, e.g. /var/log,
# provided you have permission to do so
LOG_FILE="logfile"

log () {
  printf "%s\n" "$(date +"%b %d %X :") $*" |tee -a "$LOG_FILE"
}

# Use the `log` functon like  this: 

print_me() {
  log "Lettuce log the following:"

  for file in *; do
    log "$(ls -laH "$file")"
  done

  log "Now, lettuce stop!"
}

print_me
