#!/bin/bash
set -x
set -e

export WORKSPACE=$HOME/zerovm
export GITURL=$1
export BRANCH=$2

DEPS="git gcc make g++-multilib devscripts debhelper"
sudo apt-get update
sudo apt-get install --yes --force-yes $DEPS

git clone -b $BRANCH $GITURL/zerovm.git $WORKSPACE

cd $WORKSPACE
make all
