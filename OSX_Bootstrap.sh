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



#chmod 700 OSX_Bootstrap.sh  // This command will make your file executable and TestFile is File name
sudo echo "Got root!"# to prevent asking root later, comment in needed
# MARK: - BREW PACKAGES
PACKAGES=(
    svn # needed for fonts
    carthage
    swiftlint # linter for swift
    sourcery # codegen for swift
    swiftgen # codegen for swift
    git
    gh # github cli
    npm
    python
    python3
    pypy
    tree
    vim
    wget
    tldr # a simplified and community-driven version of usual Unix man pages that cuts to the chase
    jq # command-line JSON processor
    speedtest-cli # web speedtest
    you-get # fetching videos from sites
)
CASKS=(
    postman
    sourcetree
    discord
    skype
    slack
    telegram
    zeplin
    the-unarchiver
    visual-studio-code
    google-chrome
    dropbox
    webtorrent
    grammarly
    tableplus # sql tool
    1clipboard # clipboard Manager
)
FONTS=(
    font-roboto
    font-clear-sans
    font-open-sans
    # apple 4 fonts
    font-sf-pro
    font-sf-mono
    font-sf-compact
    font-new-york
)
RUBY_GEMS=(
    cocoapods
)

if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

echo "Installing packages..."
for pack in "${PACKAGES[@]}"; do
        if ! brew info $pack &>/dev/null; then
            brew install $pack
        else
            echo "package" $pack "is already installed"
        fi
done
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

echo "Installing cask..."
brew tap homebrew/cask
brew tap homebrew/cask-fonts

echo "Installing cask apps..."
for item in "${CASKS[@]}"; do
    if ! brew list --cask $item &>/dev/null; then
        brew install --cask $item
    else
        echo "cask" $item "is already installed"
    fi
done

echo "Installing fonts..."
for font in "${FONTS[@]}"; do
    brew reinstall $font
done

echo "Installing Ruby gems"
sudo gem install ${RUBY_GEMS[@]}

echo "Installing global npm packages..."
npm install marked -g


echo "Setup Finder preferences..."
#Show app extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

#Show Library folder
chflags nohidden ~/Library

#Show hidden files
defaults write com.apple.finder AppleShowAllFiles YES

#Show path bar:
defaults write com.apple.finder ShowPathbar -bool true

#Show status bar:
defaults write com.apple.finder ShowStatusBar -bool true

echo "Bootstrapping complete"
