#!/bin/bash
set -x
set -e
# Run ./build.sh first
# Requires `sudo apt-get install devscripts debhelper`

export WORKSPACE=$HOME/validator

cd $WORKSPACE

python packager.py "$CI_NAME" "$CI_EMAIL" $JOB_NAME 0.10
