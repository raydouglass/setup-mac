#!/usr/bin/env bash

# shellcheck source=./00-common.sh
source ./config/00-common.sh

function install_brew() {
  log "Install brew"

  source ./pkgs/brew.sh
  source ./pkgs/cask.sh

  if [ "$DEBUG" != "true" ]; then
    if ! command -v brew &>/dev/null; then
      export HOMEBREW_NO_ANALYTICS=1
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "\$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
    else
      log "Brew detected on path. Skipping brew install." "$yellow"
    fi
    run_cmd brew analytics off
  else
    log "Debug mode detected. Skipping brew install." "$yellow"
  fi

  log "Update brew"
  run_cmd brew update
  run_cmd brew upgrade
  if [[ "${SKIP_BREW_PKGS:-false}" != "true" ]]; then
    log "Installing ${#BREW_PKGS[@]} brew packages"
    run_cmd brew install --formula "${BREW_PKGS[@]}"
  else
    log "SKIP_BREW_PKGS=true, skipping installing brew packages" "$yellow"
  fi

  if [[ "${SKIP_CASK_PKGS:-false}" != "true" ]]; then
    log "Installing ${#CASK_PKGS[@]} brew casks"
    run_cmd brew install --cask "${CASK_PKGS[@]}"
  else
    log "SKIP_CASK_PKGS=true, skipping installing brew cask packages" "$yellow"
  fi
}
