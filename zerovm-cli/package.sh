#!/bin/bash
set -x
set -e
# Run ./build.sh first

CI_NAME=$1
CI_EMAIL=$2
PPA=$3

export WORKSPACE=$HOME/zerovm-cli

cd $WORKSPACE

# packager.py needs this for parsing the changelog
sudo apt-get install --yes --force-yes python-debian devscripts debhelper
# Clean any test/coverage artifacts from the clone.
# We need a pristine environment for packaging.
# Things like .tox/ .coverage, etc. will make debuild unhappy
git clean -fdX
python $HOME/packager.py "$CI_NAME" $CI_EMAIL $PPA
