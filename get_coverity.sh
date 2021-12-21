#!/bin/bash
# SPDX-FileCopyrightText: 2021 Comcast Cable Communications Management, LLC
# SPDX-License-Identifier: Apache-2.0

# Usage: get_coverity.sh working_directory token GITHUB_REPOSITORY

working=$1
token=$2
project=${3//\//\%2F}

pushd $working

if [ ! -f coverity_tool.tgz ]; then
    echo "Fetching linux64 binary coverity_tool.tgz"
    wget https://scan.coverity.com/download/linux64 \
        -q --post-data "token=$token&project=$project" -O coverity_tool.tgz
fi

if [ ! -f coverity_tool.md5 ]; then
    echo "Fetching linux64 md5"
    wget https://scan.coverity.com/download/linux64 \
        -q --post-data "token=$token&project=$project&md5=1" -O coverity_tool.md5
    echo "  coverity_tool.tgz" >> coverity_tool.md5
fi

md5sum -c coverity_tool.md5

tar -xzf coverity_tool.tgz

find . -name cov-* -exec ln -s {} coverity \;

popd
