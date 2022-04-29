#!/bin/bash
# Name: 4_1_vault_oss_server_with_integrated_storage_start.sh
# Owner: Saurav Mitra
# Description: Configure & Start Vault OSS Server with Integrated Storage Backend

source ~/.bash_profile
cd ${VAULT_OSS_HOME}

# Vault Config
tee ${VAULT_OSS_HOME}/config.hcl &>/dev/null <<EOF
storage "raft" {
    path = "${VAULT_OSS_HOME}/data"
    node_id = "oss-node1"
}

listener "tcp" {
    address = "127.0.0.1:8200"
    tls_disable = 1
}

cluster_name = "oss_vault_cluster"
api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"
ui = true
EOF

# Stop Vault Enterprise (single node localhost)
kill -9  `ps | grep config.hcl | grep -v grep | awk '{ print $1 }'`
sleep 5

# Start Vault Server
nohup vault server -config=${VAULT_OSS_HOME}/config.hcl &
