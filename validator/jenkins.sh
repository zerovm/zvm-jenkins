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

lxc_run () {
    sudo lxc-attach -n $JOB_NAME-$BUILD_NUMBER -- "$*"
}

echo "Installing wget..."
lxc_run sudo apt-get install --yes --force-yes wget
echo "Deploying build script..."
lxc_run wget --no-check-certificate $RAWGITURL/zvm-jenkins/master/validator/build.sh
echo "Running build script..."
lxc_run sh build.sh $GITURL $BRANCH

echo "Deploying packaging scripts..."
lxc_run wget --no-check-certificate $RAWGITURL/zvm-jenkins/master/validator/package.sh
lxc_run wget --no-check-certificate $RAWGITURL/zvm-jenkins/master/packager.py
echo "Creating packages..."
lxc_run sh package.sh "$CI_NAME" "$CI_EMAIL"
