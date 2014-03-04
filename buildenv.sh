#!/bin/bash

set -x
set -e

LXC_TEMPLATE="zvm"
# TODO: Add a real check for these
# The following env vars should be set:
# - JOB_NAME (set by jenkins)
# - BUILD_NUMBER (set by jenkins)
# - GITURL
# - RAWGITURL

CURRENT_JOB_ID=$JOB_NAME-$BUILD_NUMBER

# clone an lxc container
sudo lxc-clone -o $LXC_TEMPLATE -n $CURRENT_JOB_ID
# start lxc, daemonized
sudo lxc-start -n $CURRENT_JOB_ID -d
