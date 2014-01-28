#!/bin/bash
# Jenkins build/test script for the zvm-toolchain
# See $GITURL/toolchain
set -x
set -e

export WORKSPACE=$HOME/zvm-toolchain  # Root working directory
export GITURL=$1                      # example: "$GITURL"
export TOOLCHAIN_BRANCH=$2            # branch of the toolchain to build
export REMOTE_PKG_REPO_DIR=$3

sudo apt-get update
sudo apt-get install --yes --force-yes dpkg-dev

echo "deb file:$REMOTE_PKG_REPO_DIR ./" | sudo tee -a /etc/apt/sources.list
cd $REMOTE_PKG_REPO_DIR
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
sudo apt-get update
# We need to install this first before adding the ZVM repo,
# so that we can install the local/latest version
sudo apt-get install --yes --force-yes zerovm-zmq zerovm-zmq-dev
sudo su -c 'echo "deb [ arch=amd64 ] http://zvm.rackspace.com/v1/repo/ubuntu/ precise main" > /etc/apt/sources.list.d/zerovm-precise.list'
wget -O- https://zvm.rackspace.com/v1/repo/ubuntu/zerovm.pkg.key | sudo apt-key add -
sudo apt-get update

# install package deps
DEPS="git libc6-dev-i386 libglib2.0-dev pkg-config build-essential automake"
DEPS="$DEPS autoconf libtool g++-multilib texinfo flex bison groff gperf"
DEPS="$DEPS texinfo subversion libzmq3 libzmq3-dev"
sudo apt-get install --yes --force-yes $DEPS

# we need zrt to build the toolchain
export ZRT_ROOT=$HOME/zrt
git clone $GITURL/zrt.git $ZRT_ROOT
# Pull the main source repo:
git clone -b $TOOLCHAIN_BRANCH $GITURL/toolchain.git $WORKSPACE
cd $WORKSPACE/SRC
git clone $GITURL/linux-headers-for-nacl.git
git clone $GITURL/gcc.git
git clone $GITURL/glibc.git
git clone $GITURL/newlib.git
git clone $GITURL/binutils.git
cd $WORKSPACE
echo "Building toolchain..."
make -j8
