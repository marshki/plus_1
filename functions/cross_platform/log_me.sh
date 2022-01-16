#!/usr/bin/env bash 
# Create log file and write to it when called. 

LOG_FILE="logfile.sh.log"

log () {
  printf "%s\n" "$(date +"%b %d %X :") $*" |tee -a "$LOG_FILE"
}

log "Now hear dis!"

# Use like this, e.g.: 

# Replace 1st occurrence of "find_string" with "replace_string" in all files.

#string_rename() {
#  printf "%s\n\n" "Renaming files..."

#  for file in *; do
    log "$(mv -v "$file" "${file/$find_string/$replace_string}")"
#  done

#  printf "\n%s\n\n" "Done."
#}
