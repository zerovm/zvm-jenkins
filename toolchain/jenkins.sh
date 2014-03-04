#!/bin/bash
set -x
set -e
# The following variables need to be set:
# - GITURL
# - RAWGITURL
# - LOCAL_PKG_DIR
# - REMOTE_PKG_REPO_DIR

lxc_run () {
    sudo lxc-attach -n $JOB_NAME-$BUILD_NUMBER -- "$*"
}

lxc_run sudo apt-get update
lxc_run sudo apt-get install --yes --force-yes wget

echo "Deploying packages..."
# TODO: simply move the packages into the rootfs on the host.
lxc_run mkdir $REMOTE_PKG_REPO_DIR
for f in $LOCAL_PKG_DIR/*.deb; do
    lxc_run sh -c "cat > $REMOTE_PKG_REPO_DIR/$(basename $f)" < $f
done

echo "Deploying build script..."
lxc_run wget $RAWGITURL/zvm-jenkins/master/toolchain/build.sh
lxc_run chmod +x ./build.sh
echo "Running build script. This could take a while..."
lxc_run ./build.sh $GITURL $BRANCH $REMOTE_PKG_REPO_DIR

# TODO: deploy/run test script
# TODO: deploy/run package script
