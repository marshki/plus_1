#!/bin/bash 
# Create log file and write to it when called. 

LOG_FILE="bulky.sh.log"

log () {
  printf "%s\n" "$(date +"%b %d %X :") $*" |tee -a "$LOG_FILE"
}

log "Now hear dis!"
