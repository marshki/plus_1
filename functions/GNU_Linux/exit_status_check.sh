#!/bin/bash
# Check exit status of program. 

print_me () { 
  printf "%s\\n" "Print me." 
} 

retVal=$? 

if [[ $retVal -ne 0 ]]; then
  printf "%s\\n" "Something went wrong, homie..."
fi

printf "%s\\n" "exit $retVal"
