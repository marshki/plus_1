#!/usr/bin/env bash
# Detect system architecture, then act.
  
os_check() {

    case $(uname -s) in
    Darwin)

      printf "%s\n" "Darwin"
      ;;
    Linux)

      printf "%s\n" "Linux"
      ;;
    *)

      printf "%s\n" "He can't handle your speed, $(uname -s)"
      ;;
    esac
}

os_check
