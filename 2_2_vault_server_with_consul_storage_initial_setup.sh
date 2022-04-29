#!/bin/bash
# Name: 2_2_vault_server_with_consul_storage_initial_setup.sh
# Owner: Saurav Mitra
# Description: Initialize Vault Enterprise Server with Consul Storage Backend & Setup sample Auth/Secrets
# Test UI: http://127.0.0.1:8200/ui/

source ~/.bash_profile
cd ${VAULT_ENT_HOME}

# Initialize Vault Server
export VAULT_ADDR=http://127.0.0.1:8200
vault status
vault operator init -key-shares=3 -key-threshold=2 > ${VAULT_ENT_HOME}/vault_server_with_consul_storage_init.txt

ENT_UNSEAL_KEY_1=`grep "Unseal Key 1" ${VAULT_ENT_HOME}/vault_server_with_consul_storage_init.txt | cut -d ":" -f 2 | tr -d ' '`
ENT_UNSEAL_KEY_2=`grep "Unseal Key 2" ${VAULT_ENT_HOME}/vault_server_with_consul_storage_init.txt | cut -d ":" -f 2 | tr -d ' '`
ENT_UNSEAL_KEY_3=`grep "Unseal Key 3" ${VAULT_ENT_HOME}/vault_server_with_consul_storage_init.txt | cut -d ":" -f 2 | tr -d ' '`
ENT_ROOT_TOKEN=`grep "Initial Root Token" ${VAULT_ENT_HOME}/vault_server_with_consul_storage_init.txt | cut -d ":" -f 2 | tr -d ' '`

echo "export ENT_UNSEAL_KEY_1=${ENT_UNSEAL_KEY_1}" >> ${VAULT_POC_HOME}/variables
echo "export ENT_UNSEAL_KEY_2=${ENT_UNSEAL_KEY_2}" >> ${VAULT_POC_HOME}/variables
echo "export ENT_UNSEAL_KEY_3=${ENT_UNSEAL_KEY_3}" >> ${VAULT_POC_HOME}/variables
echo "export ENT_ROOT_TOKEN=${ENT_ROOT_TOKEN}" >> ${VAULT_POC_HOME}/variables
source ~/.bash_profile


# Unseal Vault Server
vault operator unseal ${ENT_UNSEAL_KEY_1}
vault operator unseal ${ENT_UNSEAL_KEY_2}
vault status
vault login ${ENT_ROOT_TOKEN}


# Demo Actions to Add Vault Policies, Auth Methods, Secret Engines & Audit
vault policy write admin ${VAULT_POC_HOME}/admin-policy.hcl
vault policy write kvread ${VAULT_POC_HOME}/kv-read-policy.hcl
vault policy list

vault auth enable userpass
vault write auth/userpass/users/admin password=Password123456 policies=admin
vault auth enable -path=approle approle
vault write auth/approle/role/dev-webapp policies=kv-read
vault auth list

vault secrets enable -version=2 -path=kv kv
vault secrets enable -version=2 -path=secret kv
sleep 5
vault kv put kv/dev_db_creds name=admin pass=password
vault secrets enable -path=transit transit
vault write -f transit/keys/dev_webapp_key
vault secrets list
vault kv get kv/dev_db_creds

vault audit enable -path=audit_file file file_path=${VAULT_ENT_HOME}/audit.log
vault audit list


# Enterprise Features
vault namespace create dev
vault namespace list

POLICY=$(base64 ${VAULT_POC_HOME}/cidr-check.sentinel)
vault write sys/policies/egp/cidr-check policy="${POLICY}" paths="secret/*" enforcement_level="hard-mandatory"
POLICY=$(base64 ${VAULT_POC_HOME}/business-hrs.sentinel)
vault write sys/policies/egp/business-hrs policy="${POLICY}" paths="secret/accounting/*" enforcement_level="soft-mandatory"
vault read sys/policies/egp/cidr-check
vault read sys/policies/egp/business-hrs
vault kv put secret/accounting/test acct_no="293472309423"


# Snapshot Backup
export CONSUL_HTTP_ADDR=https://127.0.0.1:8501
export CONSUL_CACERT=${CONSUL_OSS_HOME}/consul-agent-ca.pem
export CONSUL_CLIENT_CERT=${CONSUL_OSS_HOME}/dc1-server-consul-0.pem
export CONSUL_CLIENT_KEY=${CONSUL_OSS_HOME}/dc1-server-consul-0-key.pem

${CONSUL_OSS_HOME}/consul snapshot save ${CONSUL_OSS_HOME}/consul-vault-backup.snap
${CONSUL_OSS_HOME}/consul snapshot inspect ${CONSUL_OSS_HOME}/consul-vault-backup.snap
