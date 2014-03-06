#!/bin/bash
set -x
set -e

export WORKSPACE=$HOME/zpm
export GITURL=$1
export BRANCH=$2

sudo apt-get update
sudo apt-get install --yes --force-yes python-pip
sudo pip install tox

git clone $GITURL/zpm.git
cd $WORKSPACE
git fetch origin +refs/pull/*:refs/remotes/origin/pr/*
git checkout $BRANCH

tox
