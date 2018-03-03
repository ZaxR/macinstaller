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
echo "alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'" >> ~/.bash_profile
source ~/.bash_profile


#Install GNU core utilities (those that come with OS X are outdated)
echo "Installing GNU core utilities…"
brew tap homebrew/dupes
brew install coreutils
brew install gnu-sed --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-indent --with-default-names
brew install gnu-which --with-default-names
brew install gnu-grep --with-default-names


#Install new Bash
echo "Installing new Bash…"
brew install bash bash-completion
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'


#Switch to Zsh
echo "Installing zsh…"
brew install zsh zsh-completions
sudo -s 'echo /usr/local/bin/zsh >> /etc/shells'
chsh -s /usr/local/bin/zsh `#Switch default to new bash`
echo 'source ~/.bash_profile' >> ~/.zshrc


#Add oh-my-zsh, theme, plugins, powerline fonts
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "ZSH_THEME='agnoster'" >> ~/.zshrc
echo "plugins=colored-man-pages git gitfast pyenv python sublime zsh-autosuggestions zsh-syntax-highlighting" >> ~/.zshrc


#Install other binaries
binaries=(
  ack `#like grep, but optimized for programmers`
  freetype
  git
  graphviz
  heroku-toolbelt
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
heroku update


#Install apps to /Applications
apps=(
  alfred
  caffeine
  dash
  disk-inventory-x
  dropbox
  firefox
  flash-player
  flux
  gimp
  gitkraken
  google-chrome
  handbrake
  iterm2
  itsycal
  mkchromecast
  namechanger
  slack
  spectacle
  sublime-text 
  the-unarchiver
  virtualbox
  vagrant
  vlc
)

brew tap caskroom/versions
echo "Installing apps to /Applications…"
brew cask install --appdir="/Applications" ${apps[@]}


#Set default text editor, git name, and github username/password
git config --global core.editor "subl -n -w"
git config --global user.name "Zax"
git config --global credential.helper osxkeychain


#Install Google SDK, update path, enable zsh completion
brew cask install --appdir="/Applications" google-cloud-sdk
source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc


#Cleanup
brew cleanup --force
rm -f -r /Library/Caches/Homebrew/*


#Set up OS tweaks
echo "Tweaking OS settings…"

#Enable right click; logging out and back in is required to take effect
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true

#Enable tap to click; logging out and back in is required to take effect
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

#Show status bar
defaults write com.apple.finder ShowStatusBar -bool true
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

#Change default text editor to Sublime Text 3
defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add \
'{LSHandlerContentType=public.plain-text;LSHandlerRoleAll=com.sublimetext.3;}'

#Finished!
echo "Done!"


#Manual Installs
#Pycharm CE or Pro
#Docker for Mac  
#Flycut clipboard `#Alfred has this, but you need to buy the powerpack for $19`
