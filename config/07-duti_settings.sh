#!/usr/bin/env bash

# shellcheck source=./00-common.sh
source ./config/00-common.sh

function duti_settings() {
  log "Setting default apps via duti"

  if command -v duti &>/dev/null; then
    VIDEO_EXTS=(mov mp4 m4v mkv avi mp4 flv wmv webm mpg mpeg)
    for ext in "${VIDEO_EXTS[@]}"; do
      run_cmd duti -s org.videolan.vlc "$ext" all
    done
  else
    log "duti not found on path! Skipping duti settings." "$red"
  fi
}
