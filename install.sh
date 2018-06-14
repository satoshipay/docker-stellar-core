#!/usr/bin/env bash

set -ue

# install deps
apt-get update
apt-get install -y $STELLAR_CORE_BUILD_DEPS

# clone, compile, and install stellar core
git clone --branch $STELLAR_CORE_VERSION --recursive --depth 1 https://github.com/stellar/stellar-core.git

cd stellar-core
./autogen.sh
./configure
make
make install
cd ..

# install confd for config file management
wget -nv -O /usr/local/bin/confd https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64
chmod +x /usr/local/bin/confd

# cleanup
rm -rf stellar-core
apt-get remove -y $STELLAR_CORE_BUILD_DEPS
apt-get autoremove -y

# install gcloud and gsutil
apt-get update -qq
apt-get install lsb-release curl -y
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "CLOUD_SDK_REPO: $CLOUD_SDK_REPO"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
apt-get update -qq
apt-get install google-cloud-sdk -qqy

# install deps
apt-get install -y $STELLAR_CORE_DEPS

# cleanup apt cache
rm -rf /var/lib/apt/lists/*
