#!/bin/bash
# Jenkins build/test script for the zvm-toolchain
# See https://github.com/zerovm/toolchain
set -x
set -e

export WORKSPACE=$HOME/zvm-toolchain  # Root working directory
export GITURL=$1        # example: "https://github.com/zerovm"
export TOOLCHAIN_BRANCH=$2     # branch of the toolchain to build

# Pull the main source repo:
git clone --recursive -b $TOOLCHAIN_BRANCH $GITURL/toolchain.git $WORKSPACE

# NOTE: the following one-time setup steps are required:
## add custom repo for zeromq libs (libzmq3-dev):
# sudo su -c 'echo "deb [ arch=amd64 ] http://zvm.rackspace.com/v1/repo/ubuntu/ precise main" > /etc/apt/sources.list.d/zerovm-precise.list'
# wget -O- https://zvm.rackspace.com/v1/repo/ubuntu/zerovm.pkg.key | sudo apt-key add -
## install packages:
# sudo apt-get update
# sudo apt-get install libc6-dev-i386 libglib2.0-dev pkg-config git libzmq3-dev build-essential automake autoconf libtool g++-multilib texinfo subversion lzma

# a place to clone deps from git:
# export OTHER_LIBS="$WORKSPACE/other_libs"

# set env vars:
export ZVM_PREFIX=$HOME/zerovm
export ZRT_ROOT=$HOME/zrt
# We need headers from zrt:
git clone $GITURL/zrt.git $ZRT_ROOT

# build toolchain:
cd $WORKSPACE
# cd $OTHER_LIBS/zvm-toolchain
echo "Building toolchain..."
make -j8

