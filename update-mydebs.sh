#!/bin/bash
PKG_REPO_DIR=$1
cd $PKG_REPO_DIR
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
