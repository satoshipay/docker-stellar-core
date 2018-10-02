#!/usr/bin/env bash

set -ue

# install aws cli
apt-get update
apt-get install -y python-pip
pip install awscli

# cleanup apt cache
rm -rf /var/lib/apt/lists/*
