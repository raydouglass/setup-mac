#!/usr/bin/env bash

# shellcheck source=./00-common.sh
source ./config/00-common.sh

function macos_settings () {
  log "Configuring MacOS settings"

  run_cmd defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
  run_cmd mkdir -p ~/Pictures/Screenshots/
  run_cmd defaults write com.apple.screencapture location ~/Pictures/Screenshots/
  run_cmd defaults write com.apple.screencapture "disable-shadow" -bool "true"
  run_cmd killall SystemUIServer

  run_cmd defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
  run_cmd defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
  run_cmd defaults write com.apple.finder "ShowPathbar" -bool "true"
  # List folders first
  # run_cmd defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"
  # Search current folder in Finder
  run_cmd defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"
  # Empty trash after 30 days
  run_cmd defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"
  run_cmd defaults write com.apple.finder "ShowHardDrivesOnDesktop" -bool "true"
  run_cmd defaults write com.apple.finder "ShowExternalHardDrivesOnDesktop" -bool "true"
  run_cmd defaults write com.apple.finder "ShowRemovableMediaOnDesktop" -bool "true"
  run_cmd defaults write com.apple.finder "ShowMountedServersOnDesktop" -bool "true"
  run_cmd killall Finder

  run_cmd defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool "true"

  # Expand the save panel by default
  run_cmd defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  run_cmd defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  run_cmd defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  run_cmd defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
  # Save to disk, rather than iCloud, by default
  run_cmd defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
  run_cmd defaults write NSGlobalDomain KeyRepeat -int 0
  run_cmd defaults write com.apple.screensaver askForPassword -int 1
  run_cmd defaults write com.apple.screensaver askForPasswordDelay -int 0

  run_cmd defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
}
