#!/bin/bash
set -x
set -e
# run the build script remotely in the LXC
# TODO: Add a real check for these
# The following env vars should be set:
# - IP
# - GITURL
# - BRANCH
# - RAWGITURL
# - CI_NAME
# - CI_EMAIL
# - PPA

echo "Installing wget..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "sudo apt-get install --yes --force-yes wget"
echo "Deploying build script..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "wget --no-check-certificate $RAWGITURL/zvm-jenkins/master/validator/build.sh"
ssh ubuntu@$IP -oStrictHostKeyChecking=no "chmod +x ./build.sh"
echo "Running build script..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "./build.sh $GITURL $BRANCH"

echo "Deploying packaging scripts..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "wget --no-check-certificate $RAWGITURL/zvm-jenkins/master/validator/package.sh"
ssh ubuntu@$IP -oStrictHostKeyChecking=no "wget --no-check-certificate $RAWGITURL/zvm-jenkins/master/packager.py"
ssh ubuntu@$IP -oStrictHostKeyChecking=no "chmod +x ./package.sh"
echo "Creating and publishing packages to $PPA..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "./package.sh \"$CI_NAME\" \"$CI_EMAIL\" $PPA"
