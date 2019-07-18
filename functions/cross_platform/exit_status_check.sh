#!/bin/bash
# Check exit status of program. 
# The print statments are mostly for demonstrative purposes. 

print_me () { 
  printf "%s\\n" "Print me."  
} 

print_me

retVal=$? 

exit_status () { 
  if [[ $retVal -ne 0 ]]; then
    printf "%s\\n" "Something went wrong, homie."
  else
    printf "%s\\n" "Done."
  fi
} 

exit_status

printf "%s\\n" "exit $retVal"
