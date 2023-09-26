#!/usr/bin/env bash
# Add user via dscl utility.
# Adds user WITHOUT creating directory in /Users.

username='sjobs'
increment_uid='502'
realname='Steve Jobs'
primarygroup='20'
passhint='1...'
pass2='1morething'

create_user() {
	
  printf "%s\\n" "Adding user..."

  dscl . -create /Users/"$username"
  dscl . -create /Users/"$username" UniqueID "$increment_uid"
  dscl . -create /Users/"$username" UserShell /bin/bash
  dscl . -create /Users/"$username" RealName "$realname"
  dscl . -create /Users/"$username" PrimaryGroupID "$primarygroup"
  dscl . -create /Users/"$username" NFSHomeDirectory /Users/$username
  dscl . -create /Users/"$username" hint "$passhint"
  dscl . -passwd /Users/"$username" "$pass2"
}

create_user
