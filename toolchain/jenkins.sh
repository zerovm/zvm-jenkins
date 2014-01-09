#!/bin/bash

# GITURL needs to be set
# RAWGITURL needs to be set


echo "Fetching package dependenices, publishing to local pkg repo..."
scp -oStrictHostKeyChecking=no $LOCAL_PKG_DIR/*.deb ubuntu@$IP:$REMOTE_PKG_REPO_DIR
ssh ubuntu@$IP -oStrictHostKeyChecking=no "./update-mydebs.sh $REMOTE_PKG_REPO_DIR"
ssh ubuntu@$IP -oStrictHostKeyChecking=no "sudo apt-get update"
ssh ubuntu@$IP -oStrictHostKeyChecking=no "sudo apt-get install --yes --force-yes zerovm-zmq-dev"

# run the build script remotely in the LXC
echo "Deploying build script..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "wget $RAWGITURL/zvm-jenkins/master/toolchain/build.sh"
ssh ubuntu@$IP -oStrictHostKeyChecking=no "chmod +x ./build.sh"
echo "Running build script. This could take a while..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "./build.sh $GITURL $BRANCH"

echo "Deploying test script..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "wget $RAWGITURL/zvm-jenkins/master/toolchain/test.sh"
ssh ubuntu@$IP -oStrictHostKeyChecking=no "chmod +x ./test.sh"
echo "Running tests..."
ssh ubuntu@$IP -oStrictHostKeyChecking=no "sh test.sh"
