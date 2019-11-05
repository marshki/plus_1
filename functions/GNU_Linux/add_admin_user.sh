#!/bin/bash
# Check OS for administrative group via `getent`, 
# then, using `usermod`, add user to group. 
# sudo = Debian-based 
# wheel = RHEL-based 

admin_group_check () { 
    if ! getent group sudo || ! getent group wheel
    then 
        printf "%s\\n" "No admin group found."
    fi
}
admin_group_check 
