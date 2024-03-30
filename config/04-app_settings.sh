#!/usr/bin/env bash

# shellcheck source=./00-common.sh
source ./config/00-common.sh

function app_settings() {
  log "Configure app settings"

  # Add code symlink
  log "Add vscode symlink"
  vscode_app_code="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
  if command -v code &> /dev/null; then
    log "Found code on path already: $(which code)" "$yellow"
  else
    log "code is not on the path, adding symlink to ~/.local/bin"
    if [ -f "$vscode_app_code" ]; then
      mkdir -p "$HOME/.local/bin"
      run_cmd ln -s "$vscode_app_code" "$HOME/.local/bin/code"
    else
      log "Error: $$vscode_app_code not found!" "$red"
    fi
  fi

  # iterm2 settings
  log "Setting iterm2 preferences directory"
  # Specify the preferences directory
  run_cmd defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/.iterm2"
  # Tell iTerm2 to use the custom preferences in the directory
  run_cmd defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

  # gh config
  log "Setting gh config"
  if command -v gh &> /dev/null; then
    run_cmd gh config set git_protocol ssh
    run_cmd gh config set editor "code --wait"
    run_cmd gh config set prompt enabled
  else
    log "Error: gh not found!" "$red"
  fi

  # itsycal settings
  log "Configuring ItsyCal settings"
  run_cmd defaults write com.mowglii.ItsycalApp ClockFormat -string "E MMM d h:mm a"
  run_cmd defaults write com.mowglii.ItsycalApp ShowEventDays 7
  run_cmd defaults write com.mowglii.ItsycalApp HideIcon 1


  # Chrome settings
  log "Configuring Chrome settings"
  # Use the system-native print preview dialog
  run_cmd defaults write com.google.Chrome DisablePrintPreview -bool true
  run_cmd defaults write com.google.Chrome.canary DisablePrintPreview -bool true
}
