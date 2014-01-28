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

echo "deb file:$REMOTE_PKG_REPO_DIR ./" | sudo tee -a /etc/apt/sources.list
cd $REMOTE_PKG_REPO_DIR
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
sudo su -c 'echo "deb [ arch=amd64 ] http://zvm.rackspace.com/v1/repo/ubuntu/ precise main" > /etc/apt/sources.list.d/zerovm-precise.list'
wget -O- https://zvm.rackspace.com/v1/repo/ubuntu/zerovm.pkg.key | sudo apt-key add -
sudo apt-get update

# Install deps
DEPS="git gcc make g++-multilib pkg-config libglib2.0-dev devscripts debhelper"
DEPS="$DEPS libvalidator0 libzmq3-dev"
sudo apt-get install --yes --force-yes $DEPS

# Clone and build
git clone -b $BRANCH $GITURL/zerovm.git $WORKSPACE
cd $WORKSPACE
make all
