#!/bin/bash

# GITURL needs to be set
# RAWGITURL needs to be set

CURRENT_JOB_ID=$JOB_NAME-$BUILD_NUMBER
IP=""

get_ip () {
    IP=`cat /var/lib/misc/dnsmasq.leases | grep "\s$CURRENT_JOB_ID\s" | awk '{print $3}'`
}

# clone an lxc container
sudo lxc-clone -o $JOB_NAME -n $CURRENT_JOB_ID
# start lxc, daemonized
sudo lxc-start -n $CURRENT_JOB_ID -d

# get the IP of the machine
get_ip

if [ -z "${IP}" ]; then
    # it may take some time for the IP lease to take effect,
    # so we can try multiple times before failing
    times=(1 2 4 8)
    for t in "${times[@]}"; do
        echo "No IP yet assigned to LXC $CURRENT_JOB_ID -- waiting for $t seconds"
        sleep $t
        get_ip
        if [ -z "${IP}" ]; then
            # not yet defined
            continue
        else
            break
        fi
    done
fi

if [ -z "${IP}" ]; then
    echo "The LXC has did not get an IP"
    exit 1
fi

# run the build script remotely in the LXC
ssh ubuntu@$IP "wget $RAWGITURL/zvm-jenkins/master/build-zvm-toolchain.sh"
ssh ubuntu@$IP "./build-zvm-toolchain.sh $WORKSPACE $GITURL"

# stop lxc
sudo lxc-stop -n $CURRENT_JOB_ID
# destroy lxc
sudo lxc-destroy -n $CURRENT_JOB_ID
echo "Build complete!"
