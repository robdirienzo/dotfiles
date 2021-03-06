#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

set -e

export DOTFILES=$HOME/.dotfiles

# Include utilities
. $HOME/.dotfiles/lib/utils.zsh

macports_check () {
  if [ -a /opt/local ] || \
    [ -a /Applications/DarwinPorts ] || \
    [ -a /Applications/MacPorts ] || \
    [ -a /Library/LaunchDaemons/org.macports.* ] || \
    [ -a /Library/Receipts/DarwinPorts*.pkg ] || \
    [ -a /Library/Receipts/MacPorts*.pkg ] || \
    [ -a /Library/StartupItems/DarwinPortsStartup ] || \
    [ -a /Library/Tcl/darwinports1.0 ] || \
    [ -a /Library/Tcl/macports1.0 ] || \
    [ -a ~/.macports ]
    then
    # stuff
    return 0
  else
    return 1
  fi
}

macports_kill () {
  e_warning "Saving list of installed ports to /tmp/ports-installed"
  port list installed > /tmp/ports-installed

  e_header "Exterminating MacPorts"

  sudo port -fp uninstall installed

  sudo rm -rf /opt/local \
    /Applications/DarwinPorts \
    /Applications/MacPorts \
    /Library/LaunchDaemons/org.macports.* \
    /Library/Receipts/DarwinPorts*.pkg \
    /Library/Receipts/MacPorts*.pkg \
    /Library/StartupItems/DarwinPortsStartup \
    /Library/Tcl/darwinports1.0 \
    /Library/Tcl/macports1.0 \
    ~/.macports

  e_success "Success!"
}

install_homebrew () {
  e_header "Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)" 2> /tmp/homebrew-install.log
}

# Check for Homebrew
if test ! "$(which brew)"
then
  if macports_check; then
    seek_confirmation "Detected MacPorts. You can continue by removing MacPorts automatically [y], or by aborting now [n]."
    if is_confirmed; then
      seek_confirmation "N.B. If you accept, all of your MacPorts things will disappear."
      if is_confirmed; then
        macports_kill
        install_homebrew
      else
        exit 1
      fi
    else
      exit 1
    fi
  else
    install_homebrew
  fi
fi

# If `brew doctor` fails, then warn the user
if ! [[ $(brew doctor) = *"Your system is ready to brew."* ]]; then
  seek_confirmation "Homebrew is sick. Proceed with caution [y], or fix the problems [n]."
  if ! is_confirmed; then
    exit 1
  fi
fi

# Execute the `brew` operations specified in ./homebrew/Brewfile
brew bundle "$DOTFILES/homebrew/Brewfile"

# Install default Mac apps with Homebrew Cask
seek_confirmation "Would you like to install some default Mac apps?"
if is_confirmed; then
  brew bundle "$DOTFILES/homebrew/Caskfile"
fi

exit 0
