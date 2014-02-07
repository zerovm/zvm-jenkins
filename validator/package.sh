#!/bin/bash
set -x
set -e
# Run ./build.sh first
# Requires `sudo apt-get install devscripts debhelper`

CI_NAME=$1
CI_EMAIL=$2
PKG_NAME=$3
PKG_VERSION=$4

export WORKSPACE=$HOME/validator

cd $WORKSPACE

python packager.py "$CI_NAME" "$CI_EMAIL" $PKG_NAME $PKG_VERSION
