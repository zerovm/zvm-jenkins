#!/bin/bash

set -x
set -e

LXC_TEMPLATE="zvm"
# TODO: Add a real check for these
# The following env vars should be set:
# - JOB_NAME (set by jenkins)
# - BUILD_NUMBER (set by jenkins)
# - GITURL
# - RAWGITURL

CURRENT_JOB_ID=$JOB_NAME-$BUILD_NUMBER
IP=""

get_ip () {
    export IP=`cat /var/lib/misc/dnsmasq.leases | grep "\s$CURRENT_JOB_ID\s" | awk '{print $3}'`
}

# clone an lxc container
sudo lxc-clone -o $LXC_TEMPLATE -n $CURRENT_JOB_ID
# start lxc, daemonized
sudo lxc-start -n $CURRENT_JOB_ID -d

# get the IP of the machine
get_ip

if [ -z "${IP}" ]; then
    # it may take some time for the IP lease to take effect,
    # so we can try multiple times before failing
    times=(1 2 4 8 16)
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
