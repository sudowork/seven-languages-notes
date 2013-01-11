#!/bin/sh
################################################################################
#
# Install Script for
# * Build Tools
# * Homebrew
# * Ruby, Io, Prolog, Scala, Erlang, Clojure, and Haskell using homebrew
#
# Author: Yang Su, email: suyang1@gmail.com
# GitHub: https://github.com/yangsu
#
################################################################################

# Colors
RED="\033[31m"
MAGENTA="\033[32m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
GREY="\033[30m"
YELLOW="\033[1;33m"
LIGHTPURPLE="\033[1;35m"
REDBG="\033[41m\033[37m\033[1m"
GREENBG="\033[43m\033[37m\033[1m"
RESET="\033[0m\033[0;0m"
BOLD="\033[1m"

# Installation

# Check gcc
command -v gcc >/dev/null 2>&1 || {
  echo "GCC not found. Please install GCC for your version of Mac OS X using the following link" >&2
  open https://github.com/kennethreitz/osx-gcc-installer#option-1-downloading-pre-built-binaries
  exit 1;
}

echo "Installing Homebrew (http://mxcl.github.com/homebrew/)"
ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"

# sudo mkdir /usr/local/Cellar
# sudo chown -R `whoami` /usr/local

brew docter

echo "If you get \"${BOLD}Your system is raring to brew${RESET}\", Press enter to continue"
echo "Otherwise, please go to ${BOLD}http://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/$RESET, scroll to ${BOLD}Step 3: Install Homebrew"

pause

brew update

echo "Installing Ruby..."
brew install rbenv
brew install ruby-build
rbenv install 1.9.3-p194
rbenv global 1.9.3-p125

echo "Installing Io..."
brew install io

echo "Installing Prolog..."
brew install gprolog

echo "Installing Scala..."
brew install scala

echo "Installing Erlang..."
brew install erlang

echo "Installing Clojure..."
brew install clojure

echo "Installing Haskell..."
brew install ghc
brew install haskell-platform

echo "You are all Done"