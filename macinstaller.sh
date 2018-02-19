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


#Install new Bash
echo "Installing new Bash…”
brew install bash bash-completion `#v4`
sudo -s 'echo /usr/local/bin/bash >> /etc/shells' `#Add to approved shells`


#Switch to Zsh
echo "Installing zsh…”
brew install zsh zsh-completions
sudo -s 'echo /usr/local/bin/zsh >> /etc/shells' `#Add to approved shells`
chsh -s /usr/local/bin/zsh `#Switch default to new bash`
echo 'source ~/.bash_profile' >> ~/.zshrc


#Add oh-my-zsh, theme, plugins, powerline fonts
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "ZSH_THEME='agnoster'" >> ~/.zshrc
echo "plugins=(colored-man-pages git gitfast pyenv python sublime zsh-autosuggestions zsh-syntax-highlighting)" >> ~/.zshrc


#Python time!
brew install pyenv pyenv-virtualenv
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshenv
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshenv
exec "$SHELL"
pyenv install 3.6.4
pyenv install anaconda3-4.2.0
pyenv install anaconda3-5.0.1
pyenv global anaconda3-5.0.1
pip install --user git+git://github.com/Lokaltog/powerline --verbose


#Install other binaries
binaries=(
  ack `#like grep, but optimized for programmers`
  freetype
  git
  graphviz
  heroku-toolbelt
  hub `#cli wrapper for git from github that adds github operations`
  imagemagick
  libpng
  pkg-config
  postgresql
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


#Install homebrew-cask
echo "Installing homebrew-cask..."
brew install caskroom/cask/brew-cask
brew tap caskroom/versions


#Install apps to /Applications
apps=(
  alfred `#Need to manually enter a custom script to integrate in iterm`
  chromecast
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
  namechanger
  pycharm
  slack
  spectacle
  sublime-text 
  the-unarchiver
  utorrent
  virtualbox
  vagrant
  vlc
  wunderlist
)

echo "Installing apps to /Applications…"
brew cask install --appdir="/Applications" ${apps[@]}


#Set default text editor, git name, and github username/password
echo "alias git=hub" >> ~/.zshrc
git config --global core.editor "subl -n -w"
git config --global user.name "Zax"
git config --global credential.helper osxkeychain


#Install Google SDK, update path, enable zsh completion
brew cask install --appdir="/Applications" google-cloud-sdk
source /Users/zrosenberg/google-cloud-sdk/path.zsh.inc
source /Users/zrosenberg/google-cloud-sdk/completion.zsh.inc


#Cleanup
brew cleanup --force
rm -f -r /Library/Caches/Homebrew/*


#Link Cask Apps to Alfred
brew cask alfred link


#Set up OS tweaks
echo "Tweaking OS settings…"

#Enable right click; not sure which ones work right; currently done manually
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# sudo defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

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
defaults write com.apple.LaunchServices LSHandlers -array-add '{LSHandlerContentType=public.plain-text;LSHandlerRoleAll=com.sublimetext.3;}'


#Finished!
echo "Done!"


#Manual Installs
#Docker for Mac
#Amphetamine
#Flycut clipboard `#Alfred has this, but you need to buy the powerpack for $19`
#Paid: Deliveries ($4.99)
