#!/usr/bin/env bash 
#
# Should script add default directory structure? Yes/No?

# Set username.
username='sjobs'

# This is a test prompt.
decision_prompt() {
  read -r -p "Add default directory structure (y/n)? " PROMPT
  if [[ "$PROMPT" = "y" ]]; then
    printf "%s\\n" "Add 'em.";
  else
    printf "%s\\n" "Do not add 'em.";
  fi
}

# This is the actual prompt.
create_default_dirs() {
  read -r -p "Add default directory structure (y/n)? " PROMPT
  if [[ "$PROMPT" = "y" ]] && [[ -n $(command -v xdg-user-dirs-update) ]]; then
    printf "%s\\n" "Creating default directories..."
    su "${username}" -c xdg-user-dirs-update
  fi
}

create_default_dirs
