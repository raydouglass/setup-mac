#!/usr/bin/env bash
set -euo pipefail

source config/00-common.sh

if [[ "$#" != 1 ]]; then
  log "No hostname specified. It will not be changed." "$yellow"
  NEW_HOSTNAME=
else
  NEW_HOSTNAME="$1"
fi

if [ -z "${DEBUG:-}" ]; then
  log "DEBUG is not set, defaulting to true" "$red"
  DEBUG="true"
fi

if [[ "${SKIP_ALL:-false}" == "true" ]]; then
  log "SKIP_ALL=true, so skipping everything unless explicitly enabled" "$yellow"
  SKIP_BREW="${SKIP_BREW:-true}"
  SKIP_BREW_PKGS="${SKIP_BREW_PKGS:-true}"
  SKIP_CASK_PKGS="${SKIP_CASK_PKGS:-true}"
  SKIP_MINIFORGE="${SKIP_MINIFORGE:-true}"
  SKIP_MACOS_SETTINGS="${SKIP_MACOS_SETTINGS:-true}"
  SKIP_APP_SETTINGS="${SKIP_APP_SETTINGS:-true}"
  SKIP_DOCK_SETTINGS="${SKIP_DOCK_SETTINGS:-true}"
  SKIP_MAS="${SKIP_MAS:-true}"
  SKIP_DUTI_SETTINGS="${SKIP_DUTI_SETTINGS:-true}"
  log "$(env | grep "SKIP_" | sort)" "$yellow"
fi

if [ "$DEBUG" == "true" ]; then
  log "Running in debug mode!" "$red"
  echo
else
  log "Running in execution mode!"
  log "  Press ctrl-c to cancel!" "$yellow"
  sleep 3
fi

source ./config/01-install_brew.sh
source ./config/02-install_miniforge.sh
source ./config/03-macos_settings.sh
source ./config/04-app_settings.sh
source ./config/05-dock_settings.sh
source ./config/06-install_mas.sh
source ./config/07-duti_settings.sh

USERNAME="$(whoami)"
log "Running as $USERNAME" "$yellow"
echo

# Here we go.. ask for the administrator password upfront and run a
# keep-alive to update existing `sudo` time stamp until script has finished
if [ "$DEBUG" != "true" ]; then
  sudo -v
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &
fi

current_hostname="$(hostname)"
if [[ -n "$NEW_HOSTNAME" && "$current_hostname" != "$NEW_HOSTNAME" ]]; then
  log "Setting hostname to $NEW_HOSTNAME"
  run_cmd sudo scutil --set ComputerName "$NEW_HOSTNAME"
  run_cmd sudo scutil --set HostName "$NEW_HOSTNAME"
  run_cmd sudo scutil --set LocalHostName "$NEW_HOSTNAME"
  run_cmd sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$NEW_HOSTNAME"
else
  log "Hostname is '$current_hostname'." "$yellow"
fi

log "Install Rosetta"
if [[ "$(arch)" == "arm64" ]]; then
  run_cmd /usr/sbin/softwareupdate --install-rosetta --agree-to-license
else
  log "Not on arm64, so will not install Rosetta" "$yellow"
fi

function maybe_execute() {
  local func_name="$1"
  local test_var_name="$2"
  test_var_value="${!test_var_name:-"false"}"
  if [[ "$test_var_value" != "true" ]]; then
    $func_name
  else
    log "${test_var_name}=true, skipping $func_name" "$yellow"
  fi
}

maybe_execute install_brew SKIP_BREW

maybe_execute install_miniforge SKIP_MINIFORGE

maybe_execute macos_settings SKIP_MACOS_SETTINGS

maybe_execute app_settings SKIP_APP_SETTINGS

maybe_execute dock_settings SKIP_DOCK_SETTINGS

maybe_execute install_mas SKIP_MAS

maybe_execute duti_settings SKIP_DUTI_SETTINGS
