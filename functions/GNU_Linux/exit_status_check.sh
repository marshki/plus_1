#!/bin/bash
# Check exit status of program. 

print_me () { 
  printf "%s\\n" "Print me."  
} 

print_me

retVal=$? 

if [[ $retVal -ne 0 ]]; then
  printf "%s\\n" "Something went wrong, homie..."
else
  printf "%s\\n" "Done."
fi

printf "%s\\n" "exit $retVal"
