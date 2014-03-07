#!/bin/bash
set -x
set -e
# The following env vars should be set:
# - GIT_ORG_URL
# - GIT_PROJECT
# - BRANCH
# - RAW_GIT_ORG_URL
# - CI_NAME
# - CI_EMAIL
# - PPA (optional)

source buildenv.sh

echo "Installing wget and git..."
lxc_run sudo apt-get install --yes --force-yes wget git
echo "Deploying build script..."
lxc_run wget --no-check-certificate $RAW_GIT_ORG_URL/zvm-jenkins/master/$GIT_PROJECT/build.sh
echo "Running build script..."
lxc_run sh build.sh $GIT_ORG_URL $BRANCH

echo "Deploying packaging scripts..."
lxc_run wget --no-check-certificate $RAW_GIT_ORG_URL/zvm-jenkins/master/package.sh
lxc_run wget --no-check-certificate $RAW_GIT_ORG_URL/zvm-jenkins/master/packager.py
echo "Creating packages..."
if [ -n "${PPA}" ]; then
    echo "Publishing packages to $PPA..."
fi
lxc_run sh package.sh "$CI_NAME" "$CI_EMAIL" $GIT_PROJECT $PPA
