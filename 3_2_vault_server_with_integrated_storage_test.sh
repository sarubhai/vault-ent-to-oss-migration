#!/bin/bash
# Name: 3_2_vault_server_with_integrated_storage_test.sh
# Owner: Saurav Mitra
# Description: Unseal Vault Enterprise Server with Integrated Storage Backend & Test

source ~/.bash_profile
cd ${VAULT_ENT_HOME}

# Initialize Vault Server
export VAULT_ADDR=http://127.0.0.1:8200
vault status

# Unseal Vault Server
vault operator unseal ${ENT_UNSEAL_KEY_1}
vault operator unseal ${ENT_UNSEAL_KEY_2}
vault status
vault login ${ENT_ROOT_TOKEN}
vault operator raft list-peers

# Test
vault policy list
vault auth list
vault secrets list
vault kv get kv/dev_db_creds
vault audit list

vault namespace list
vault read sys/policies/egp/cidr-check
vault read sys/policies/egp/business-hrs
vault kv get secret/accounting/test


# DROP Enterprise Features
vault delete sys/namespaces/dev
vault namespace list

vault delete sys/policies/egp/cidr-check
vault delete sys/policies/egp/business-hrs
vault read sys/policies/egp/cidr-check
vault read sys/policies/egp/business-hrs


# Snapshot Backup
vault operator raft snapshot save vault-ent-backup.snap
