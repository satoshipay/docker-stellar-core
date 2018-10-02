#!/usr/bin/env bash

set -ue

# set up gcloud apt repo
LSB_RELEASE="stretch"
export CLOUD_SDK_REPO="cloud-sdk-${LSB_RELEASE}"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# install gcloud sdk
apt-get update
apt-get install -y google-cloud-sdk

# cleanup apt cache
rm -rf /var/lib/apt/lists/*
