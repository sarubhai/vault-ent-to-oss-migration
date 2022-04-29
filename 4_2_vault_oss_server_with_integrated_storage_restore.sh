#!/bin/bash
# Name: 4_2_vault_oss_server_with_integrated_storage_restore.sh
# Owner: Saurav Mitra
# Description: Initialize Vault OSS Server with Integrated Storage Backend & Restore Enterprise Snapshot

source ~/.bash_profile
cd ${VAULT_OSS_HOME}

# Initialize Vault Server
export VAULT_ADDR=http://127.0.0.1:8200
vault status
vault operator init -key-shares=3 -key-threshold=2 > ${VAULT_OSS_HOME}/vault_server_with_integrated_storage_init.txt

export OSS_UNSEAL_KEY_1=`grep "Unseal Key 1" ${VAULT_OSS_HOME}/vault_server_with_integrated_storage_init.txt | cut -d ":" -f 2 | tr -d ' '`
export OSS_UNSEAL_KEY_2=`grep "Unseal Key 2" ${VAULT_OSS_HOME}/vault_server_with_integrated_storage_init.txt | cut -d ":" -f 2 | tr -d ' '`
export OSS_UNSEAL_KEY_3=`grep "Unseal Key 3" ${VAULT_OSS_HOME}/vault_server_with_integrated_storage_init.txt | cut -d ":" -f 2 | tr -d ' '`
export OSS_ROOT_TOKEN=`grep "Initial Root Token" ${VAULT_OSS_HOME}/vault_server_with_integrated_storage_init.txt | cut -d ":" -f 2 | tr -d ' '`


# Unseal Vault Server
vault operator unseal ${OSS_UNSEAL_KEY_1}
vault operator unseal ${OSS_UNSEAL_KEY_2}
vault status
sleep 20
vault login ${OSS_ROOT_TOKEN}
vault operator raft list-peers


# Restore Enterprise Backup
vault operator raft snapshot restore -force ${VAULT_ENT_HOME}/vault-ent-backup.snap


# Unseal Vault Server
# USE THE ENTERPRISE UNSEAL KEYS
vault operator unseal ${ENT_UNSEAL_KEY_1}
vault operator unseal ${ENT_UNSEAL_KEY_2}
vault status
sleep 20
vault login ${ENT_ROOT_TOKEN}
vault operator raft list-peers


# Validate Vault Policies, Auth Methods & Secret Engines
# Test
vault policy list
vault auth list
vault secrets list
vault kv get kv/dev_db_creds
vault audit list
vault namespace list
