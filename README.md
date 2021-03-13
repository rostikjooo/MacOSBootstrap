# MacDevBootstrap
it's a cusomizable script to setup new MacOS  machine
with basic casual and software developer tools

## Tools used
- homebrew
    * homebrew/core
    * homebrew/cask
    * homebrew/cask-fonts
- Node Package Manager
- RubyGems

## Usage
1. Install _Xcode Command Line Tools_ (installs with Xcode from AppStore)
```zsh
$ xcode-select --install
```
2. Do the rest
```zsh
git clone https://github.com/rostikjooo/MacOSDevBootstrap.git;
cd MacOSDevBootstrap;
chmod 700 OSX_Bootstrap.sh;
./OSX_Bootstrap.sh;
cd ..;
rm -rf MacOSBootstrap;
```
