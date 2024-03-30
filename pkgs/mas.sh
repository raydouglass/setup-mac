#!/usr/bin/env bash

# Get app IDs by searching `"App Name" macOs app store` or by visiting the app's page on the App Store, Share/Copy Link
# The URL will be like this: https://apps.apple.com/us/app/microsoft-remote-desktop/id1295203466
# The app ID is the number at the end of the URL (i.e. 1295203466)

# If you already have `mas` installed: `mas search "App Name"`
# Or `mas list` for currently installed apps

# name=>app ID
declare -A MAS_PKGS=(
    ["Amphetamine"]=937984704
    ["iMovie"]=408981434
    ["Microsoft Remote Desktop"]=1295203466
    ["SQLPro for SQLite"]=586001240
    ["Telegram"]=747648890
    ["The Unarchiver"]=425424353
    ["WireGuard"]=1451685025
)
export MAS_PKGS
