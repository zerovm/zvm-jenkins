#!/bin/bash
set -x
set -e
# run the build script remotely in the LXC
# The following env vars should be set:
# - GITURL
# - BRANCH
# - RAWGITURL
# - CI_NAME
# - CI_EMAIL
# - PPA

echo "Installing wget..."
lxc_run sudo apt-get install --yes --force-yes wget

echo "Deploying build script..."
lxc_run wget --no-check-certificate $RAWGITURL/zvm-jenkins/master/zpm/build.sh
echo "Running build script..."
lxc_run sh build.sh $GITURL $BRANCH

echo "Grabbing test and coverage reports..."
get_ip
lxc_scp ubuntu@$IP:/home/ubuntu/zerovm-cli/junit.xml ./junit.xml
lxc_scp -r ubuntu@$IP:/home/ubuntu/zerovm-cli/htmlcov ./

echo "Deploying packaging scripts..."
lxc_run wget --no-check-certificate $RAWGITURL/zvm-jenkins/master/zerovm-cli/package.sh
lxc_run wget --no-check-certificate $RAWGITURL/zvm-jenkins/master/packager.py
echo "Creating and publishing packges to $PPA..."
lxc_run sh package.sh "$CI_NAME" "$CI_EMAIL" $PPA
