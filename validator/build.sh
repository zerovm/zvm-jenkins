#!/bin/bash
set -x
set -e

export WORKSPACE=$HOME/validator
export GITURL=$1
export BRANCH=$2

DEPS="gcc make g++-multilib devscripts debhelper autoconf automake libtool"
sudo apt-get update
sudo apt-get install --yes --force-yes $DEPS

git clone $GITURL/validator.git $WORKSPACE
cd $WORKSPACE
git fetch origin +refs/pull/*:refs/remotes/origin/pr/*
git checkout $BRANCH

./autogen.sh
./configure
make
make clean
