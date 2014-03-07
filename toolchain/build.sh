#!/bin/bash
set -x
set -e

export WORKSPACE=$HOME/toolchain
export GITURL=$1
export BRANCH=$2

export ZRT_ROOT=$HOME/zrt
export ZVM_PREFIX=$HOME/zvm-root
export LD_LIBRARY_PATH=/usr/lib64
export CPATH=/usr/x86_64-nacl/include

# Toolchain sublibs
TC_LIBS="linux-headers-for-nacl gcc glibc newlib binutils"

DEPS="git libc6-dev-i386 libglib2.0-dev pkg-config build-essential automake"
DEPS="$DEPS autoconf libtool g++-multilib texinfo flex bison groff gperf"
DEPS="$DEPS texinfo subversion libzmq3 libzmq3-dev zerovm-zmq zerovm-zmq-dev"

sudo apt-get update
sudo apt-get install --yes --force-yes python-software-properties
sudo add-apt-repository ppa:zerovm-ci/zerovm-latest
sudo apt-get update
sudo apt-get install --yes --force-yes $DEPS

# we need zrt to build the toolchain as well:
git clone $GITURL/zrt.git $ZRT_ROOT

git clone $GITURL/toolchain.git $WORKSPACE

cd $WORKSPACE/SRC
for lib in $TC_LIBS; do
    git clone $GITURL/$lib.git
done

cd $WORKSPACE
git fetch origin +refs/pull/*:refs/remotes/origin/pr/*
git checkout $BRANCH

echo "Building toolchain. This could take a while..."
make -j8 ZEROVM=`which zerovm`

# Clean build artifacts before we continue to packaging:
for lib in $TC_LIBS; do
    cd $WORKSPACE/SRC/$lib
    git reset --hard
    git clean -fd
done
