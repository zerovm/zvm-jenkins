#!/bin/bash
set -x
set -e
# run the build script remotely in the LXC
# The following env vars should be set:
# - IP
# - GITURL
# - BRANCH
# - RAWGITURL


echo "Installing wget..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "sudo apt-get install --yes --force-yes wget"

echo "Deploying build script..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "wget $RAWGITURL/zvm-jenkins/master/zpm/build.sh"
ssh ubuntu@$IP -oStrictHostKeyChecking=no "chmod +x ./build.sh"
echo "Running build script..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "./build.sh $GITURL $BRANCH"
