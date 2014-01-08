#!/bin/bash
set -x
set -e

export WORKSPACE=$HOME/zerovm
export GITURL=$1
export BRANCH=$2

git clone -b $BRANCH $GITURL/zerovm.git $WORKSPACE

cd $WORKSPACE
make all
