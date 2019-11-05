#!/bin/bash
# Check OS for administrative group via `getent`,
# then, using `usermod`, add user to group.
# sudo = Debian-based
# wheel = RHEL-based

admin_group_check () {

    if [ "$(getent group sudo)" ]
    then
        printf "%s\\n" "sudo group exists..."

    elif [ "$(getent group wheel)" ]
    then
        printf "%s\\n" "wheel group exists..."

    else
        if ! [ "$(getent group sudo)" ] && ! [ "$(getent group wheel)" ]
        then
            printf "%s\\n" "ERROR: No admin group found. Exiting." >&2
            exit 1
        fi
    fi
}

admin_group_check
