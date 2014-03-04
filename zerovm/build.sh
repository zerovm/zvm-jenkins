#!/bin/bash
set -x
set -e

export WORKSPACE=$HOME/zerovm
export GITURL=$1
export BRANCH=$2

DEPS="git gcc make g++-multilib pkg-config libglib2.0-dev devscripts debhelper"
DEPS="$DEPS zvm-validator libzmq3-dev"

sudo apt-get install --yes --force-yes python-software-properties
sudo add-apt-repository ppa:zerovm-ci/zerovm-latest
sudo apt-get update
sudo apt-get install --yes --force-yes $DEPS

git clone -b $BRANCH $GITURL/zerovm.git $WORKSPACE

cd $WORKSPACE
make all
