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

echo "Please install GCC and other build tools using the following link"
open https://github.com/kennethreitz/osx-gcc-installer#option-1-downloading-pre-built-binaries

echo -e "Press enter to continue ${GREEN}after installing GCC"
read

echo "Installing Homebrew (http://mxcl.github.com/homebrew/)"
# ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"

echo "Installing Ruby..."
# brew install ruby

echo "Installing Io..."
# brew install io

echo "Installing Prolog..."
# brew install gprolog

echo "Installing Scala..."
# brew install scala

echo "Installing Erlang..."
# brew install erlang

echo "Installing Clojure..."
# brew install clojure

echo "Installing Haskell..."
# brew install ghc
# brew install haskell-platform

echo "You are all Done"