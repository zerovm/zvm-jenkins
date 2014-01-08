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
# - LOCAL_PKG_DIR


echo "Fetching package dependencies, publishing to local pkg repo..."
# TODO: Revise this--don't copy all packages, just the ones we need
# NOTE: The package file name can change from version to version
scp -oStrictHostKeyChecking=no $LOCAL_PKG_DIR/*.deb ubuntu@$IP:$REMOTE_PKG_REPO_DIR
ssh ubuntu@$IP -oStrictHostKeyChecking=no "./update-mydebs.sh $REMOTE_PKG_REPO_DIR"
ssh ubuntu@$IP -oStrictHostKeyChecking=no "sudo apt-get update"
ssh ubuntu@$IP -oStrictHostKeyChecking=no "sudo apt-get install --yes --force-yes libvalidator0"

echo "Deploying build script..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "wget $RAWGITURL/zvm-jenkins/master/zerovm/build.sh"
ssh ubuntu@$IP -oStrictHostKeyChecking=no "chmod +x ./build.sh"
echo "Running build script..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "./build.sh $GITURL $BRANCH"

echo "Deploying packaging script..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "wget $RAWGITURL/zvm-jenkins/master/zerovm/package.sh"
ssh ubuntu@$IP -oStrictHostKeyChecking=no "chmod +x ./package.sh"
echo "Creating packages..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "./package.sh"

# Copy the built package to the host machine,
# so that other build jobs can use it.
echo "Saving the built deb package..."
scp -oStrictHostKeyChecking=no ubuntu@$IP:/home/ubuntu/*.deb $LOCAL_PKG_DIR
