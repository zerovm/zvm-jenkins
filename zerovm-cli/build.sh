#!/bin/bash
set -x
set -e

export WORKSPACE=$HOME/zerovm-cli
export GITURL=$1
export BRANCH=$2

sudo apt-get update
sudo apt-get install --yes --force-yes python-pip
sudo pip install tox

# Clone and build
git clone -b $BRANCH $GITURL/zerovm-cli.git $WORKSPACE
cd $WORKSPACE
tox -e py27,py3,pep8,pyflakes,full
