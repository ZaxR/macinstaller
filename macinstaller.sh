#!/usr/bin/env bash

#Begin by installing Xcode from the App Store
#Check if Xcode is installed with xcode-select –p
#Install Command Line Tools via Xcode


#Install Homebrew, if not already installed
echo "alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'" >> ~/.bash_profile
source ~/.bash_profile

if [ ! $(which brew) ]; then
  echo "Installing Homebrew…"
  ruby -e "$(curl -fsSl https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
else
  echo "Updating and cleaning Homebrew…"
  brewup
fi


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


#Install and switch to Zsh
echo "Installing Zsh…"
brew install zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting
sudo -s 'echo /usr/local/bin/zsh >> /etc/shells'
chsh -s /usr/local/bin/zsh #Switch default shell to Zsh

#Add oh-my-zsh, theme, plugins, powerline fonts
echo "Installing and configuring oh-my-zsh…"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sed -i -e 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc
sed -i -e 's/  git/  colored-man-pages\n  git\n  python\n  sublime/g' ~/.zshrc

#Add basic Zsh configuration
echo "Configuring Zsh…"
echo -e 'source ~/.bash_profile\n' | cat - ~/.zshrc > temp && mv temp ~/.zshrc
echo "export DEFAULT_USER=\`whoami\`" >> ~/.zshrc
echo "source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
echo "source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc


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


#Set Git's default text editor, name, and credential helper
echo "Configuring Git…"
git config --global core.editor "subl -n -w"
git config --global user.name "Zax"
git config --global credential.helper osxkeychain


#Install Google SDK, update PATH, enable Zsh completion
echo "Installing Google SDK…"
brew cask install --appdir="/Applications" google-cloud-sdk
source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc


#Clean up after Homebrew
echo "Cleaning up…"
brewup
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

#Show hidden programs by default. Allows using ⌘+H to hide, and ⌘+Tab switching
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
#If this command doesn't work, see http://ultimatemac.com/how-to-change-default-text-editor-on-mac/ for manual instructions
defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add \
'{LSHandlerContentType=public.plain-text;LSHandlerRoleAll=com.sublimetext.3;}'


#Finished!
echo "Done! Don't forget to make manual changes noted at the end of the installer script."


#Manual Installs/Steps
#Install Pycharm CE or Pro
#Install Docker for Mac  
#Install Flycut clipboard - Alfred has this, but you need to buy the powerpack for $19

##Enabling 'tap to click' via CLI no longer works since Sierra. Manually configure via System Preferences > Trackpad
##Enable tap to click; logging out and back in is required to take effect
#sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
#sudo defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
#sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

#Configure iTerm settings
  #Manually configure iTerm for word jumps (option + → or ←) and word deletion (option + backspace). 
    #iTerm > Preferences > Profiles > Keys > Load Preset... > select 'Natural Text Editing'
  #Colors
    #iTerm > Preferences > Profiles > Colors > Color Presets... > select 'Solarized Dark'
  #Install a patched font
    #Download Meslo by clicking 'view raw' at https://github.com/powerline/fonts/blob/master/Meslo%20Slashed/Meslo%20LG%20M%20Regular%20for%20Powerline.ttf .
    #Open the downloaded font and press "Install Font".
    #iTerm > Preferences > Profiles > Text > Change Font > select '13pt Meslo LG L Regular for Powerline'
    #Restrat iTerm2
