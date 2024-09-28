#!/usr/bin/env bash
#
# Check exit status of program.
# (Print statments are for demonstrative purposes).

# Sample function.
print_me() { 
  printf "%s\n" "Print me."  
} 

print_me

# Capture exit status of command to retVal.
retVal=$? 

# If retVal not 0, let us know.
exit_status() {
  if [[ $retVal != 0 ]]; then
    printf "%s\n" "Something went wrong, homie."
  else
    printf "%s\n" "Done."
  fi
}

exit_status

printf "%s\n" "exit $retVal"
