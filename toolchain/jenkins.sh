#!/bin/bash
set -x
set -e
# The following variables need to be set:
# - IP
# - GITURL
# - RAWGITURL
# - LOCAL_PKG_DIR
# - REMOTE_PKG_REPO_DIR


ssh ubuntu@$IP -oStrictHostKeyChecking=no "sudo apt-get update"
ssh ubuntu@$IP -oStrictHostKeyChecking=no "sudo apt-get install --yes --force-yes wget"

echo "Deploying packages..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "mkdir $REMOTE_PKG_REPO_DIR"
scp -oStrictHostKeyChecking=no $LOCAL_PKG_DIR/*.deb ubuntu@$IP:$REMOTE_PKG_REPO_DIR

echo "Deploying build script..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "wget $RAWGITURL/zvm-jenkins/master/toolchain/build.sh"
ssh ubuntu@$IP -oStrictHostKeyChecking=no "chmod +x ./build.sh"
echo "Running build script. This could take a while..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "./build.sh $GITURL $BRANCH $REMOTE_PKG_REPO_DIR"

# TODO: deploy/run test script
# TODO: deploy/run package script
