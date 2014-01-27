#!/bin/bash
set -x
set -e

export WORKSPACE=$HOME/zerovm
export GITURL=$1
export BRANCH=$2
export REMOTE_PKG_REPO_DIR=$3

sudo apt-get update
# need this to run a local pkg repo
sudo apt-get install --yes --force-yes dpkg-dev

# scan for packages in the local package repo
cd $REMOTE_PKG_REPO_DIR
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz

sudo echo $REMOTE_PKG_REPO_DIR >> /etc/apt/sources.list

# Install deps
DEPS="git gcc make g++-multilib devscripts debhelper libvalidator0"
sudo apt-get install --yes --force-yes $DEPS

# Clone and build
git clone -b $BRANCH $GITURL/zerovm.git $WORKSPACE
cd $WORKSPACE
make all
