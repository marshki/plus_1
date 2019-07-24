# plus_1

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d9aaccd5c21741989e69e273117f1d45)](https://www.codacy.com/app/marshki/plus_1?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=marshki/plus_1&amp;utm_campaign=Badge_Grade)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/hyperium/hyper/master/LICENSE)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity)
[![Open Source Love svg3](https://badges.frapsoft.com/os/v3/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)

Bash script to create local user account in: 
GNU Linux (via *useradd*), and macOS (via *dscl*). 

## Getting Started 

This tool was developed for sysadmins managing user acounts on servers 
**not** tied to a network identity manager,
but will work just as well in desktop environments.

Place the script in: `/usr/local/bin` 

set the executable bit on the file:

`chmod +x /plus_1.sh`   

then call it:

`sudo bash plus1.sh` 

and follow the on-screen prompts. 

## TODO: 

-- Password hint prompt for macOS. 
 
## History
v.0.2 2019.07.24

## License 
[LICENSE](https://github.com/marshki/plus_1/blob/master/LICENSE).
