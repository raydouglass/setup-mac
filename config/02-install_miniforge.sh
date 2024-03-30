#!/usr/bin/env bash

# shellcheck source=./00-common.sh
source ./config/00-common.sh

function install_miniforge() {
  log "Install Miniforge3"
  if [ "$DEBUG" != "true" ]; then
    if ! command -v conda &>/dev/null; then
      curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" &&
        bash "Miniforge3-$(uname)-$(uname -m).sh" -b -f &&
        rm "Miniforge3-$(uname)-$(uname -m).sh"
    else
      log "Conda detected on path. Skipping Miniforge3 install." "$yellow"
    fi
  else
    log "Debug mode detected. Skipping Miniforge3 install." "$yellow"
  fi
}
