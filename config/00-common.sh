#!/usr/bin/env bash

# Terminal colors
black='\033[0;30m'
white='\033[0;37m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'

export black white red green yellow blue magenta cyan

# Resets the style
reset=$(tput sgr0)

# Log some text with an optional color
function log () {
  local color="$green"
  if [ -n "${2:-}" ]; then
    color="$2"
  fi
  while IFS= read -r line; do
    echo -e "${color}[$(date)] $line${reset}"
  done <<< "${1}"
}

function log_cmd () {
  echo -e "[$(date)]   $*"
}

# Execute a command if not in debug mode
function run_cmd () {
  log_cmd "$*"
  if [ "$DEBUG" != "true" ]; then
    "$@"
  fi
}
