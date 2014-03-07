#!/bin/bash
set -x
set -e
# Run ./build.sh first
# Requires `sudo apt-get install devscripts debhelper`

CI_NAME=$1
CI_EMAIL=$2
WORKSPACE=$HOME/$3  # $3 if the GIT_PROJECT jenkins job var
PPA=$4

cd $WORKSPACE

# packager.py needs this for parsing the changelog
sudo apt-get install --yes --force-yes python-debian
python $HOME/packager.py "$CI_NAME" $CI_EMAIL $PPA
