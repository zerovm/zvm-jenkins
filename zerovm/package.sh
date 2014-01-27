#!/bin/bash
set -x
set -e
# Run ./build.sh first
# Requires `sudo apt-get install devscripts debhelper`

export WORKSPACE=$HOME/zerovm

cd $WORKSPACE
git archive HEAD --output ../zerovm-zmq_0.9.4.orig.tar
gzip ../zerovm-zmq_0.9.4.orig.tar
debuild -us -uc --source-option=--include-binaries
