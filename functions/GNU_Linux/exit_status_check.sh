#!/bin/bash
# Check exit status of program. 

if [[ $? -gt 0 ]] ; then
  printf "%s\\n" "Something went wrong, homie..."
fi

exit 0
