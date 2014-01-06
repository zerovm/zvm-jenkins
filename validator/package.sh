#!/bin/bash
set -x
set -e
# Run ./build.sh first
# Requires `sudo apt-get install devscripts debhelper`

export WORKSPACE=$HOME/validator

cd $WORKSPACE
git archive HEAD --output ../libvalidator0_0.9.orig.tar
gzip ../libvalidator0_0.9.orig.tar
debuild -us -uc --source-option=--include-binaries

