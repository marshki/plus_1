#!/usr/bin/env bash
# sysadminctl implementation of create_user.sh in this directory

sysadminctl -addUser username -fullName "User Name" -UID 1001 -shell /bin/bash -password password
