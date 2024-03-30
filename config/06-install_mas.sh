#!/usr/bin/env bash

# shellcheck source=./00-common.sh
source ./config/00-common.sh

function install_mas() {
  source ./pkgs/mas.sh

  log "Installing ${#MAS_PKGS[@]} MAS packages"
  if command -v mas &> /dev/null; then
    for mas_pkg_name in "${!MAS_PKGS[@]}"; do
      mas_pkg_id="${MAS_PKGS[$mas_pkg_name]}"
      log "Installing ${mas_pkg_name} ($mas_pkg_id)"
      run_cmd mas install "$mas_pkg_id"
    done
  else
    log "mas not found on path! Skipping MAS packages." "$red"
  fi
}
