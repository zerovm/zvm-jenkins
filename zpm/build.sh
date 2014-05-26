#!/bin/bash
set -x
set -e

export WORKSPACE=$HOME/zpm
export GITURL=$1
export BRANCH=$2

git clone $GITURL/zpm.git $WORKSPACE
cd $WORKSPACE
git fetch origin +refs/pull/*:refs/remotes/origin/pr/*
git checkout $BRANCH
