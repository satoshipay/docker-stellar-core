#!/usr/bin/env bash

set -ue

# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# cleanup apt cache
rm -rf /var/lib/apt/lists/*
