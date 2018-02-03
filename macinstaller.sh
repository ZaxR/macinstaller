#!/bin/sh

#Begin by installing xcode from the appstore
#Check if xcode is installed with xcode-select –p
#Install Command Line Tools


#Install Homebrew, if not already installed
if test ! $(which brew); then
  echo "Installing homebrew"
  ruby -e "$(curl -fsSl https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update


#Install GNU core utilities (those that come with OS X are outdated)
echo "Installing GNU core utilities…”
brew tap homebrew/dupes
brew install coreutils
brew install gnu-sed --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-indent --with-default-names
brew install gnu-which --with-default-names
brew install gnu-grep --with-default-names

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils


#Switch to new Bash
echo "Installing new Bash…”
brew install bash `#v4`
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells' `#Add to approved shells`
chsh -s /usr/local/bin/bash `#Switch default to new bash`
brew install bash-completion


#Install other binaries
binaries=(
  ack `#like grep, but optimized for programmers`
  freetype
  git
  graphviz
  heroku-toolbelt
  hub
  imagemagick
  libpng
  pkg-config
  postgresql
  python3
  redis
  rename
  tmux
  tree
  vim
  wget
)

echo "Installing binaries..."
brew install ${binaries[@]}


#Install homebrew-cask
echo "Installing homebrew-cask..."
brew install caskroom/cask/brew-cask
brew tap caskroom/versions
brew cleanup


#Install apps to /Applications
apps=(
  alfred `#Need custom iterm script for integration`
  anaconda
  chromecast
  dash
  disk-inventory-x
  dropbox
  firefox
  flash-player
  flux
  gimp
  github
  google-chrome
  handbrake
  heroku-toolbelt
  iterm2
  itsycal
  namechanger
  pycharm
  slack
  sourcetree
  sublime-text 
  the-unarchiver
  transmission –or-  utorrent –or- qBittorrent
  virtualbox
  vagrant
  vlc
  wunderlist
)

echo "Installing apps to /Applications…"
brew cask install --appdir="/Applications" ${apps[@]}


#Cleanup
brew cleanup --force
rm -f -r /Library/Caches/Homebrew/*


#Link Cask Apps to Alfred
brew cask alfred link


#Set up OS tweaks
echo "Tweaking OS settings…"

#Enable right click; not sure which ones work right
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
sudo defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

#Show hidden programs by default. Allows using Command+H to hide, and Command+Tab switching
defaults write com.apple.Dock showhidden -bool TRUE
killall Dock

#Remove Dock delay
defaults write com.apple.Dock autohide-delay -float 0
killall Dock

#Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool TRUE
killall Finder

#Show long path name on all folders
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
killall Finder

#Show file extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
killall Finder

#Disable drop shadows on a screenshot
defaults write com.apple.screencapture disable-shadow -bool TRUE
killall SystemUIServer

# Check for macOS updates daily instead of weekly
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Prevent Apps From Saving to iCloud by Default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool FALSE

#Enable debug menu
defaults write com.apple.appstore ShowDebugMenu -bool true


#Finished!
echo "Done!"


#Manual Installs
#Docker for Mac
#Bettersnaptool
#Amphetamine
#Flycut clipboard `#Alfred has this, but you need to buy the powerpack for $19`
#Paid: Tower
#Paid: Deliveries ($4.99)
