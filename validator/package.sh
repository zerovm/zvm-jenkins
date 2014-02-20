#!/bin/bash
set -x
set -e
# Run ./build.sh first
# Requires `sudo apt-get install devscripts debhelper`

CI_NAME=$1
CI_EMAIL=$2
PPA=$3

export WORKSPACE=$HOME/validator

cd $WORKSPACE

# packager.py needs this for parsing the changelog
sudo apt-get install python-debian
python $HOME/packager.py "$CI_NAME" "$CI_EMAIL" $PPA
