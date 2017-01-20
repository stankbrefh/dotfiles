#!/bin/sh

# DISCLAIMER: This script assumes Xcode Developer Tools are already 
# installed and that user is installing on a BASH shell.

# Installs Homebrew, git, rbenv with a version of ruby, and rspec

ruby_version='2.3.1'

# ---------- PATH ----------

# remove scripts that might adversely effect the environment install
echo "Deleting existing environment profiles..."
test -e $HOME/.bash_profile && rm $HOME/.bash_profile
test -e $HOME/.bashrc && rm $HOME/.bashrc
test -e $HOME/.bash_login && rm $HOME/.bash_login
test -e $HOME/.profile && rm $HOME/.profile
test -e $HOME/.zlogin && rm $HOME/.zlogin
test -e $HOME/.zshrc && rm $HOME/.zshrc
test -e $HOME/.mkshrc && rm $HOME/.mkshrc

# start with a clean osx standard PATH
echo "Resetting PATH variable..."
PATH='/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin'
# ---------- Homebrew ----------

# check if Homebrew is installed
which -s brew
# if not,
[[ $? > 0 ]] && {
  # install it
  echo 'Installing Homebrew...'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
}

# ---------- Git ----------

# check if git is installed in /usr/local (i.e. via homebrew)
if [[ -e /usr/local/bin/git ]]; then
  echo -"Re-linking git to fix any broken symlinks..."
  # relink to fix any broken symlinks
  brew unlink git
  brew link git
# check if git is installed, but not linked
elif [[ -d /usr/local/Cellar/git ]]; then 
  echo -e  'Git is already installed. Linking git...'
  brew link git
# otherwise install git
else
  echo 'Installing git...'
  brew install git
fi

# There's a known issue with updating Homebrew if you upgraded to OSX Sierra, we'll run the fix just in case
echo 'Updating Homebrew...'
cd $(brew --repository) && git fetch && git reset --hard origin/master
cd ~
brew update
echo 'Updating packages...'
brew upgrade

# ---------- rbenv ----------

# uninstall rvm
[[ -d $HOME/.rvm ]] && {
  echo 'Un-installing RVM...'
  [[ $(which -s rvm) ]] && rvm implode --force
  rm -rf $HOME/.rvm
  echo '\n'
}

# if rbenv is not installed with Homebrew, install it
[[ ! -d $HOME/.rbenv || ! -e /usr/local/bin/rbenv ]] && {
  echo 'Installing rbenv...'
  brew install rbenv
}
# if Ruby version isn't installed, install it
[[ ! -d $HOME/.rbenv/versions/$ruby_version ]] && {
  echo "Installing Ruby can take a while, please be patient."
  rbenv install $ruby_version
}
# set global Ruby version
echo "Setting Ruby version to $ruby_version..."
rbenv global $ruby_version
# temporarily edit path to install gems
echo "Temporarily prepending rbenv shims to path..."
shims="$HOME/.rbenv/shims"
export PATH="$shims:$PATH"
# install rspec
echo "Installing rspec..."
gem install rspec
echo "Installing Interactive Editor"
gem install interactive_editor
rbenv rehash

# ---------- Sublime ----------

echo "Creating Sublime symlink..."

test -d /Applications/Sublime\ Text\ 2.app/ && {
  test /usr/local/bin/subl && rm /usr/local/bin/subl
  mkdir -p /usr/local/bin/
  ln -s /Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl
  exit 0
}

test -d /Applications/Sublime\ Text.app/ && {
  test /usr/local/bin/subl && rm /usr/local/bin/subl
  mkdir -p /usr/local/bin/
  ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl
  exit 0
}

exit 0