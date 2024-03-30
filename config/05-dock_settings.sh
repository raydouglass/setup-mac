#!/usr/bin/env bash

# shellcheck source=./00-common.sh
source ./config/00-common.sh

function dock_settings() {
  log "Configure dock settings"

  run_cmd defaults write com.apple.dock "orientation" -string "bottom"
  run_cmd defaults write com.apple.dock "show-recents" -bool "true"

  log "Removing everything from the dock"
  run_cmd defaults write com.apple.dock persistent-apps -array
  run_cmd defaults write com.apple.dock recent-apps -array
  run_cmd defaults write com.apple.dock persistent-others -array

  PERSISTANT_APPS=(
    "/Applications/Google Chrome.app"
    "/Applications/Slack.app"
    "/System/Applications/Messages.app"
    "/Applications/Skype.app"
    "/Applications/Visual Studio Code.app"
    "/Applications/iTerm.app"
    "/System/Applications/System Settings.app"
  )
  log "Add persistant dock apps"
  for app in "${PERSISTANT_APPS[@]}"; do
    add_app_to_dock "$app"
  done

  log "Add directories to dock"
  add_folder_to_dock "/Applications" -a 1 -d 1 -v 2
  add_folder_to_dock "/Users/$USERNAME" -a 1 -d 1 -v 2
  add_folder_to_dock "/Users/$USERNAME/Documents" -a 1 -d 1 -v 2
  add_folder_to_dock "/Users/$USERNAME/Downloads" -a 3 -d 1 -v 1

  log "Restarting the dock"
  run_cmd killall Dock
}

# Adapted from https://gist.github.com/kamui545/c810eccf6281b33a53e094484247f5e8

# adds an application to macOS Dock
# usage: add_app_to_dock "Application Name"
# example add_app_to_dock "/System/Applications/Music.app"
function add_app_to_dock {
  app="${1}"
  # if open -Ra "${app}"; then
  if [[ -d "$app" ]]; then
    run_cmd defaults write com.apple.dock persistent-apps -array-add \
      "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>${app}</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
  else
    log "ERROR: Application $1 not found." "$red"
  fi
}

# adds a folder to macOS Dock
# usage: add_folder_to_dock "Folder Path" -a n -d n -v n
# example: add_folder_to_dock "~/Downloads" -a 2 -d 0 -v 1
# key:
# -a or --arrangement
#   1 -> Name
#   2 -> Date Added
#   3 -> Date Modified
#   4 -> Date Created
#   5 -> Kind
# -d or --displayAs
#   0 -> Stack
#   1 -> Folder
# -v or --showAs
#   0 -> Automatic
#   1 -> Fan
#   2 -> Grid
#   3 -> List
function add_folder_to_dock {
  folder="${1}"
  arrangement="1"
  displayAs="0"
  showAs="0"

  while [[ "$#" -gt 0 ]]; do
    case $1 in
    -a | --arrangement)
      if [[ $2 =~ ^[1-5]$ ]]; then
        arrangement="${2}"
      fi
      ;;
    -d | --displayAs)
      if [[ $2 =~ ^[0-1]$ ]]; then
        displayAs="${2}"
      fi
      ;;
    -v | --showAs)
      if [[ $2 =~ ^[0-3]$ ]]; then
        showAs="${2}"
      fi
      ;;
    esac
    shift
  done

  if [ -d "$folder" ]; then
    run_cmd defaults write com.apple.dock persistent-others -array-add \
      "<dict><key>tile-data</key><dict><key>arrangement</key><integer>${arrangement}</integer><key>displayas</key><integer>${displayAs}</integer><key>file-data</key><dict><key>_CFURLString</key><string>file://${folder}</string><key>_CFURLStringType</key><integer>15</integer></dict><key>file-type</key><integer>2</integer><key>showas</key><integer>${showAs}</integer></dict><key>tile-type</key><string>directory-tile</string></dict>"
  else
    log "ERROR: Folder $folder not found." "$red"
  fi
}

function add_spacer_to_dock {
  defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
}

function add_small_spacer_to_dock {
  defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
}
