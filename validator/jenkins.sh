#!/bin/bash
set -x
set -e
# The following env vars should be set:
# - GITURL
# - BRANCH
# - RAWGITURL
# - CI_NAME
# - CI_EMAIL
# - PPA (optional)

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
if [ -n "${PPA}" ]; then
    echo "Publishing packages to $PPA..."
fi
lxc_run sh package.sh "$CI_NAME" "$CI_EMAIL" $PPA
