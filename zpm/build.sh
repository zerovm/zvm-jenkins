#!/bin/bash
set -x
set -e

export WORKSPACE=$HOME/zpm
export GITURL=$1
export BRANCH=$2

sudo apt-get update
sudo apt-get install --yes --force-yes python-pip
sudo pip install tox

# Clone and build
git clone -b $BRANCH $GITURL/zpm.git $WORKSPACE
cd $WORKSPACE
tox
