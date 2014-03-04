#!/bin/bash
set -x
set -e
# Run ./build.sh first
# Requires `sudo apt-get install devscripts debhelper`

CI_NAME=$1
CI_EMAIL=$2
PPA=$3

export WORKSPACE=$HOME/zerovm

cd $WORKSPACE

sudo apt-get install --yes --force-yes python-debian
python $HOME/packager.py "$CI_NAME" "$CI_EMAIL" $PPA
