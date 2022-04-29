#!/bin/bash
# Name: 0_setup.sh
# Owner: Saurav Mitra
# Description: Setup the Binaries & Directories for Vault & Consul
# Purpose: Simulate the migration-
#          AS-IS: Vault Enterprise v1.5.7 with Consul OSS v1.8.9 as storage backend
#          TO-BE: Vault OSS v1.10.0 with Raft Integrated storage backend

VAULT_POC_HOME=$(pwd)
echo "source ${VAULT_POC_HOME}/variables" >> ~/.bash_profile


echo "export VAULT_POC_HOME=${VAULT_POC_HOME}" >> ${VAULT_POC_HOME}/variables
echo "export BINARY_DOWNLOAD=${VAULT_POC_HOME}/download" >> ${VAULT_POC_HOME}/variables
echo "export CONSUL_OSS_HOME=${VAULT_POC_HOME}/consul/v1.8.9/oss" >> ${VAULT_POC_HOME}/variables
echo "export VAULT_ENT_HOME=${VAULT_POC_HOME}/vault/v1.5.7/ent" >> ${VAULT_POC_HOME}/variables
echo "export VAULT_OSS_HOME=${VAULT_POC_HOME}/vault/v1.10.0/oss" >> ${VAULT_POC_HOME}/variables
source ~/.bash_profile

cd ${VAULT_POC_HOME}

# Initial PoC Setup
mkdir -p ${VAULT_POC_HOME}/download
mkdir -p ${VAULT_POC_HOME}/consul/v1.8.9/oss/data
mkdir -p ${VAULT_POC_HOME}/vault/v1.5.7/ent/data
mkdir -p ${VAULT_POC_HOME}/vault/v1.10.0/oss/data

# Consul OSS v1.8.9 Binary Download:
if [ ! -f "${BINARY_DOWNLOAD}/consul_1.8.9_darwin_amd64.zip" ]; then
    curl -s https://releases.hashicorp.com/consul/1.8.9/consul_1.8.9_darwin_amd64.zip -o ${BINARY_DOWNLOAD}/consul_1.8.9_darwin_amd64.zip
fi

unzip -qq -o ${BINARY_DOWNLOAD}/consul_1.8.9_darwin_amd64.zip -d ${CONSUL_OSS_HOME}/

# Vault Enterprise v1.5.7 Binary Download:
if [ ! -f "${BINARY_DOWNLOAD}/vault_1.5.7+ent_darwin_amd64.zip" ]; then
    curl -s https://releases.hashicorp.com/vault/1.5.7+ent/vault_1.5.7+ent_darwin_amd64.zip -o ${BINARY_DOWNLOAD}/vault_1.5.7+ent_darwin_amd64.zip
fi

unzip -qq -o ${BINARY_DOWNLOAD}/vault_1.5.7+ent_darwin_amd64.zip -d ${VAULT_ENT_HOME}/

# Vault OSS v1.10.0 Binary Download:
if [ ! -f "${BINARY_DOWNLOAD}/vault_1.10.0_darwin_amd64.zip" ]; then
    curl -s https://releases.hashicorp.com/vault/1.10.0/vault_1.10.0_darwin_amd64.zip -o ${BINARY_DOWNLOAD}/vault_1.10.0_darwin_amd64.zip
fi

unzip -qq -o ${BINARY_DOWNLOAD}/vault_1.10.0_darwin_amd64.zip -d ${VAULT_OSS_HOME}/
