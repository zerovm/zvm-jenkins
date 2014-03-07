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

# Try to scrape the IP from the leases file.
do_get_ip () {
    export IP=`cat /var/lib/misc/dnsmasq.leases | grep "\s$CURRENT_JOB_ID\s" | awk '{print $3}'`
}

# Attempt to get the IP of the lxc instance. If successful, bind it to the `IP`
# env var
get_ip () {
    if [ -z "${IP}" ]; then
        # it may take some time for the IP lease to take effect,
        # so we can try multiple times before failing
        times=(1 2 4 8 16)
        for t in "${times[@]}"; do
            echo "No IP yet assigned to LXC $CURRENT_JOB_ID -- waiting for $t seconds"
            sleep $t
            do_get_ip
            if [ -z "${IP}" ]; then
                # not yet defined
                continue
            else
                break
            fi
        done
    fi

    if [ -z "${IP}" ]; then
        echo "The LXC '$CURRENT_JOB_ID' did not get an IP"
        exit 1
    fi
}

# Run a command remotely on an lxc instance
lxc_run () {
    # SSH takes its positional arguments, joins them with space and
    # passes that to a shell on the remote host. The shell will remove
    # one level of quoting, so we need to add this here while we still
    # have the positional arguments in their original form.
    ssh ubuntu@$IP -oStrictHostKeyChecking=no $(printf "%q " "$@")
}

lxc_scp () {
    scp -oStrictHostKeyChecking=no $*
}

# clone an lxc container
sudo lxc-clone -o $LXC_TEMPLATE -n $CURRENT_JOB_ID
# start lxc, daemonized
sudo lxc-start -n $CURRENT_JOB_ID -d

get_ip
