#!/usr/bin/env bash
#
# Create log file and write to it when called.

# With write permission user can set the log path, e.g.:
# LOG_FILE="/var/log/logfile"
# Default is write log to dir script is executed from.
LOG_FILE="logfile"

log() {
  printf "%s\n" "$(date +"%b %d %X") $*" |tee -a "$LOG_FILE"
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
