# plus_1

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d9aaccd5c21741989e69e273117f1d45)](https://www.codacy.com/app/marshki/plus_1?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=marshki/plus_1&amp;utm_campaign=Badge_Grade)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity)
[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/hyperium/hyper/master/LICENSE)
[![Open Source Love svg3](https://badges.frapsoft.com/os/v3/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)

Bash script to create local user account(s) in: 
GNU/Linux (via *useradd*), and macOS (via *dscl*). 

## Notes 

This tool was developed for sysadmins managing user acounts on servers 
**not** tied to a network identity manager,
but will work just as well in desktop environments.
Also, there are standalone [GNU/Linux](https://github.com/marshki/plus_1/blob/master/functions/GNU_Linux/linux_add.sh) 
and [macOS](https://github.com/marshki/plus_1/blob/master/functions/macOS/macOS_add.sh) add user scripts in this repo, 
should that strike your fancy. 

![Animated SVG](https://rawcdn.githack.com/marshki/plus_1/82c4815ee2f23978dd493df8cf0b2674c31cbd36/docs/termtosvg_iicyaexq.svg)

## Getting Started

Place the script in: `/usr/local/bin` (or create it, if it does not exist). 

set the executable bit on the file:

`chmod +x /plus_1.sh`   

then call it:

`sudo bash plus_1.sh` 

and follow the on-screen prompts. 

Log file is writtern to the location the script is called from. This is user modifiable.
 
## History

|Version  |Release Date  |  
|---      |---           |
| 0.5     | 17-JUL-2024  |
| 0.4     | 26-SEP-2023  |
| 0.3     | 26-FEB-2022  |
| 0.2     | 24-JUL-2019  |
| 0.1     | 07-NOV-2019  |
| 0.0     | 01-JUN-2019  |

## License 
[LICENSE](https://github.com/marshki/plus_1/blob/master/LICENSE).

## TODO

- [ ] Test on various versions of GNU/Linux, macOS.

- [ ] Refactor GNU/Linux installers.

- [ ] Build TUI.
