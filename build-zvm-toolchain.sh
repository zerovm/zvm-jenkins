#!/bin/bash
# Jenkins build/test script for the zvm-toolchain
# See https://github.com/zerovm/toolchain
set -x
set -e

export WORKSPACE=$HOME/zvm-toolchain  # Root working directory
export GITURL=$2        # example: "https://github.com/zerovm"

# Pull the main source repo:
git clone $GITURL/toolchain.git $WORKSPACE

# NOTE: the following one-time setup steps are required:
## add custom repo for zeromq libs (libzmq3-dev):
# sudo su -c 'echo "deb [ arch=amd64 ] http://zvm.rackspace.com/v1/repo/ubuntu/ precise main" > /etc/apt/sources.list.d/zerovm-precise.list'
# wget -O- https://zvm.rackspace.com/v1/repo/ubuntu/zerovm.pkg.key | sudo apt-key add -
## install packages:
# sudo apt-get update
# sudo apt-get install libc6-dev-i386 libglib2.0-dev pkg-config git libzmq3-dev build-essential automake autoconf libtool g++-multilib texinfo subversion lzma

# a place to clone deps from git:
export OTHER_LIBS="$WORKSPACE/other_libs"

# set env vars:
export ZEROVM_ROOT=$OTHER_LIBS/zerovm
export ZVM_PREFIX=$OTHER_LIBS/zvm-root
export ZRT_ROOT=$OTHER_LIBS/zrt
export PATH=$ZVM_PREFIX/bin:$PATH

# get "submodules" of the toolchain:
cd $WORKSPACE/SRC
git clone $GITURL/linux-headers-for-nacl.git
git clone $GITURL/gcc.git
git clone $GITURL/glibc.git
git clone $GITURL/newlib.git
git clone $GITURL/binutils.git

# clone other stuff:
git clone $GITURL/zerovm.git $ZEROVM_ROOT
git clone $GITURL/validator.git $ZEROVM_ROOT/valz
git clone $GITURL/zrt.git $ZRT_ROOT

# make the validator lib available to compile zerovm:
cd $ZEROVM_ROOT/valz
make validator
ln -s ./out/Release/libvalidator.so.0.9.0 libvalidator.so.0.9.0
ln -s ./out/Release/libvalidator.so.0.9.0 libvalidator.so.0
ln -s ./out/Release/libvalidator.so.0.9.0 libvalidator.so
export LIBRARY_PATH="`pwd`"
export PATH="`pwd`:$PATH"
export LD_LIBRARY_PATH="`pwd`"

# build zerovm:
cd $ZEROVM_ROOT
make all install PREFIX=$ZVM_PREFIX

# build toolchain:
cd $WORKSPACE
# cd $OTHER_LIBS/zvm-toolchain
echo "Building toolchain..."
make -j8
echo "Make exited with $?"
exit 0
