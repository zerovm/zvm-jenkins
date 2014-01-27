#!/bin/bash
set -x
set -e

export WORKSPACE=$HOME/validator
export GITURL=$1
export BRANCH=$2

sudo apt-get update
sudo apt-get install --yes --force-yes git

git clone -b $BRANCH $GITURL/validator.git $WORKSPACE

cd $WORKSPACE
make validator
