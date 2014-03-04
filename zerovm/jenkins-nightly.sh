#!/bin/bash
set -x
set -e
# run the build script remotely in the LXC
# TODO: Add a real check for these
# The following env vars should be set:
# - GITURL
# - BRANCH
# - RAWGITURL
# - CI_NAME
# - CI_EMAIL
# - PPA

lxc_run () {
    sudo lxc-attach -n $JOB_NAME-$BUILD_NUMBER -- "$*"
}

echo "Installing wget..."
lxc_run sudo apt-get install --yes --force-yes wget

echo "Deploying build script..."
lxc_run wget --no-check-certificate $RAWGITURL/zvm-jenkins/master/zerovm/build.sh
lxc_run chmod +x ./build.sh

echo "Running build script..."
lxc_run ./build.sh $GITURL $BRANCH

echo "Deploying packaging script..."
lxc_run wget --no-check-certificate $RAWGITURL/zvm-jenkins/master/zerovm/package.sh
lxc_run wget --no-check-certificate $RAWGITURL/zvm-jenkins/master/packager.py
lxc_run chmod +x ./package.sh

echo "Creating and publishing packages..."
lxc_run ./package.sh "$CI_NAME" "$CI_EMAIL" $PPA
