#!/bin/bash

destination="gw.hpc.nyu.edu"

ping -c 1 $destination > /dev/null 2>&1

printf "%s\n" "$?"

if [ $? -ne 0 ]; then
  printf "%s\n" "ERROR!"
fi

exit $?
