# Setup a new mac

This repo has a series of scripts to setup a new Mac from scratch. It will install things like [`brew`](https://brew.sh), [`conda/mamba`](https://github.com/conda-forge/miniforge), and set various MacOS & App settings.

## Getting started

1. Sign into iCloud
2. Update MacOS
3. Open `Terminal.app`
4. Install basic tools with `xcode-select --install`
5. Clone this repo: `git clone https://github.com/raydouglass/setup-mac.git && cd setup-mac`
6. Run `env DEBUG=false ./setup_mac.sh [new_hostname]`
    - Run with `DEBUG=true` to see what would be run without making any changes
7. Reboot

### Customize the setup

#### Edit files

1. Edit `pkgs/brew.sh` to add/remove brew packages
2. Edit `pkgs/cask.sh` to add/remove brew cask packages
3. Edit `pkgs/mas.sh` to add/remove MacOS app store packages
4. Edit files in `config/` to customize MacOS' & other apps' settings

#### setup_mac.sh settings

Set environment variables to control `setup_mac.sh` execution:
  - `SKIP_ALL` - Skip everything below unless explicitly set to `false`
  - `SKIP_BREW` - Skip installing brew, brew packages, and brew cask packages
  - `SKIP_BREW_PKGS` - Skip installing brew packages
  - `SKIP_CASK_PKGS` - Skip installing brew cask packages
  - `SKIP_MINIFORGE` - Skip installing Miniforge3
  - `SKIP_MACOS_SETTINGS` - Skip setting MacOS settings
  - `SKIP_APP_SETTINGS` - Skip setting application settings
  - `SKIP_DOCK_SETTINGS` - Skip setting up the dock
  - `SKIP_MAS` - Skip installing MacOS app store packages
  - `SKIP_DUTI_SETTINGS` - Skip using duti for setting default apps

For example:
- To only install brew packages `DEBUG=false SKIP_ALL=true SKIP_BREW=false SKIP_BREW_PKGS=false ./setup_mac.sh`
- To only configure the docker: `DEBUG=false SKIP_ALL=true SKIP_DOCK_SETTINGS=false ./setup_mac.sh`

### Other macOS Settings

1. [Enable FileVault](https://support.apple.com/guide/mac-help/encrypt-mac-data-with-filevault-mh11785/mac)
2. Enable Time Machine
3. Trackpad settings
    1. Tap to Click
    2. Natural Scrolling
    3. Swipe between pages w/ three fingers
4. Enable TouchID & enroll fingerprints

## Testing

Run `env DEBUG=true ./setup_mac.sh`

## References

See:
  - http://sourabhbajaj.com/mac-setup/
  - https://www.swyx.io/new-mac-setup
  - https://macos-defaults.com/
  - https://github.com/mathiasbynens/dotfiles/blob/master/.macos
