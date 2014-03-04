#!/bin/bash
set -x
set -e
# run the build script remotely in the LXC
# The following env vars should be set:
# - GITURL
# - BRANCH
# - RAWGITURL

lxc_run () {
    sudo lxc-attach -n $JOB_NAME-$BUILD_NUMBER -- "$*"
}

echo "Installing wget..."
lxc_run sudo apt-get install --yes --force-yes wget

echo "Deploying build script..."
lxc_run wget $RAWGITURL/zvm-jenkins/master/zpm/build.sh
echo "Running build script..."
lxc_run sh build.sh $GITURL $BRANCH
