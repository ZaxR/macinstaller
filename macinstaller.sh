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
sudo bash -c 'echo /usr/local/bin/zsh >> /etc/shells'
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


#Python time!
brew install pyenv pyenv-virtualenv
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
echo -e 'if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi' >> ~/.zshrc
exec "$SHELL"

#Type 'pyenv install -l' to see a list of available versions for install
#Installing the plugin below creates the ability to also use "pyenv install-latest".
git clone https://github.com/momo-lab/pyenv-install-latest.git "$(pyenv root)"/plugins/pyenv-install-latest
pyenv install-latest
# pyenv global x.x.x to set the global version of python.

#Create iPython profile to work w/ pyenv-virtualenv
#https://medium.com/@henriquebastos/the-definitive-guide-to-setup-my-python-workspace-628d68552e14
#ipython profile create
#curl -L http://hbn.link/hb-ipython-startup-script > ~/.ipython/profile_default/startup/00-venv-sitepackages.py


#Install other binaries
binaries=(
  ack `#like grep, but optimized for programmers`
  freetype
  git
  graphviz
  heroku-toolbelt
  imagemagick
  jq `#lightweight command-line JSON processor`
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


#Install apps to /Applications
#Each has its own command to prevent errors in remaining installed if a piece of software is already installed (a cask design decision).
brew tap caskroom/versions
echo "Installing apps to /Applications…"
brew cask install --appdir="/Applications" alfred
brew cask install --appdir="/Applications" caffeine
brew cask install --appdir="/Applications" cyberduck
brew cask install --appdir="/Applications" dash
brew cask install --appdir="/Applications" disk-inventory-x
brew cask install --appdir="/Applications" dropbox
brew cask install --appdir="/Applications" firefox
brew cask install --appdir="/Applications" flash-player
brew cask install --appdir="/Applications" flux
brew cask install --appdir="/Applications" gimp
brew cask install --appdir="/Applications" gitkraken
brew cask install --appdir="/Applications" google-chrome
brew cask install --appdir="/Applications" handbrake
brew cask install --appdir="/Applications" iterm2
brew cask install --appdir="/Applications" mkchromecast
brew cask install --appdir="/Applications" namechanger
brew cask install --appdir="/Applications" slack
brew cask install --appdir="/Applications" spectacle
brew cask install --appdir="/Applications" sublime-text 
brew cask install --appdir="/Applications" the-unarchiver
brew cask install --appdir="/Applications" virtualbox
brew cask install --appdir="/Applications" vagrant
brew cask install --appdir="/Applications" vlc


#Set Git's default text editor, name, and credential helper
echo "Configuring Git…"
git config --global core.editor "subl -n -w"
git config --global user.name "Zax"
git config --global credential.helper osxkeychain


#Install Google SDK, update PATH, enable Zsh completion
echo "Installing Google SDK…"
brew cask install --appdir="/Applications" google-cloud-sdk
echo "# The next line updates PATH for the Google Cloud SDK." >> ~/.zshrc
echo "if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi" >> ~/.zshrc
echo "# The next line enables shell command completion for gcloud." >> ~/.zshrc
echo "if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'; fi" >> ~/.zshrc

# #Fix gcloud/docker integration
# gcloud components install docker-credential-gcr
# #EXIT TERMINAL COMPLETELY AND REOPEN
# docker-credential-gcr configure-docker
# screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty
# umount /var/lib/docker/overlay2
# rm -rf /var/lib/docker
# #EXIT TERMINAL COMPLETELY AND REOPEN

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
#Install Docker for Mac from https://download.docker.com/mac/stable/Docker.dmg . This avoiding having to login to download.
#Install Itsycal from https://www.mowglii.com/itsycal/ . As of OS 10.12 this must be done manually.

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
