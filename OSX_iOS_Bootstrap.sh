#!/bin/sh
###  !/usr/bin/env bash
#  OSX_iOS_Bootstrap.sh
#
#
#  Created by Rost Balanyuk on 28.04.2020.
#
# Bootstrap script for setting up a new OSX machine
#
# This should be idempotent so it can be run multiple times.
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
#
# Reading:
#
# - http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac
# - https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
# - https://news.ycombinator.com/item?id=8402079
# - http://notes.jerzygangi.com/the-best-pgp-tutorial-for-mac-os-x-ever/


# MARK: - BREW PACKAGES
PACKAGES=(
    carthage
    swiftlint # linter
    sourcery # codegen
    swiftgen # codegen
    qlcolorcode #quick loock doping
    qlmarkdown #quick loock doping
    git
    hub #github client
    npm
    python
    python3
    pypy
    tree
    vim
    wget
)
# MARK: - BREW CASK PACKAGES
CASKS=(
    maccy # clipboard manager
    insomnia # postman-like app
    postman
    sourcetree
    iterm2
    macvim
    colluquy
    skype
    slack
    telegram
    zeplin
    the-unarchiver
#    rectangle # window shorcats arranges
#    virtualbox
#    vlc
)
# MARK: - caskroom/fonts
FONTS=(
    font-inconsolidata
    font-roboto
    font-clear-sans
)
# MARK: - GEMS
RUBY_GEMS=(
    bundler # can install gems from file
    filewatcher # can run shells when file changed
    cocoapods
)
# MARK: - FOLDERS
declare -a FOLDERS=(
  'Projects'
)

echo "Starting bootstrapping"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew tap homebrew/dupes
brew install coreutils
brew install gnu-sed --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-indent --with-default-names
brew install gnu-which --with-default-names
brew install gnu-grep --with-default-names

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash


echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

echo "Installing cask..."
brew install caskroom/cask/brew-cask

echo "Installing cask apps..."
brew cask install ${CASKS[@]}

echo "Installing fonts..."
brew tap caskroom/fonts

brew cask install ${FONTS[@]}

#echo "Installing Python packages..."
#PYTHON_PACKAGES=(
#    ipython
#    virtualenv
#    virtualenvwrapper
#)
#sudo pip install ${PYTHON_PACKAGES[@]}

echo "Installing Ruby gems"

sudo gem install ${RUBY_GEMS[@]}

echo "Installing global npm packages..."
npm install marked -g

echo "Creating folder structure..."

for folder in "${FOLDERS[@]}"; do
  [[ ! -d $folder ]] && mkdir $folder
done

echo "Configuring OSX..."

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
#defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable "natural" scroll
#defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

echo "Setup Finder preferences..."
#Show Library folder
chflags nohidden ~/Library

#Show hidden files
defaults write com.apple.finder AppleShowAllFiles YES

#Show path bar:
defaults write com.apple.finder ShowPathbar -bool true

#Show status bar:
defaults write com.apple.finder ShowStatusBar -bool true

echo "Bootstrapping complete"


