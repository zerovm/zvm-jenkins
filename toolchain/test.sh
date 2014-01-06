#!/bin/bash
set -x

export WORKSPACE=$HOME/zvm-toolchain
export GITURL=https://github.com/zerovm
export OTHER_LIBS="$WORKSPACE/other_libs"
export ZEROVM_ROOT=$OTHER_LIBS/zerovm
export ZVM_PREFIX=$OTHER_LIBS/zvm-root
export ZRT_ROOT=$OTHER_LIBS/zrt
export PATH=$ZVM_PREFIX/bin:$PATH

cd $ZEROVM_ROOT/valz
export LIBRARY_PATH="`pwd`"
export PATH="`pwd`:$PATH"
export LD_LIBRARY_PATH="`pwd`"

cd $ZEROVM_ROOT
./ftests.sh
