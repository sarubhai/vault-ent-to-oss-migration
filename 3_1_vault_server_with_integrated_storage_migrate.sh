#!/bin/bash
# Name: 3_1_vault_server_with_integrated_storage_migrate.sh
# Owner: Saurav Mitra
# Description: Configure & Migrate Vault Enterprise Server from Consul to Integrated Storage Backend

source ~/.bash_profile
cd ${VAULT_ENT_HOME}

# Vault Config
tee ${VAULT_ENT_HOME}/config.hcl &>/dev/null <<EOF
storage "raft" {
    path = "${VAULT_ENT_HOME}/data"
    node_id = "ent-node1"
}

listener "tcp" {
    address = "127.0.0.1:8200"
    tls_disable = 1
}

cluster_name = "ent_vault_cluster"
api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"
ui = true
# license_path = "${VAULT_ENT_HOME}/vault-ent.hclic"
EOF


# Storage Migration Config
tee ${VAULT_ENT_HOME}/migrate.hcl &>/dev/null <<EOF
storage_source "consul" {
    address = "127.0.0.1:8501"
    path = "vault/"
    # token = "CONSUL_VAULT_TOKEN"
    scheme = "https"
    tls_ca_file   = "${CONSUL_OSS_HOME}/consul-agent-ca.pem"
    tls_cert_file = "${CONSUL_OSS_HOME}/dc1-server-consul-0.pem"
    tls_key_file  = "${CONSUL_OSS_HOME}/dc1-server-consul-0-key.pem"
}

storage_destination "raft" {
    path = "${VAULT_ENT_HOME}/data"
    node_id = "ent-node1"
}

cluster_addr = "https://127.0.0.1:8201"
EOF


# Vault must be Offline for Storage Migration
kill -9  `ps | grep config-consul.hcl | grep -v grep | awk '{ print $1 }'`
sleep 5

# Migrate Storage Backend
vault operator migrate -config=${VAULT_ENT_HOME}/migrate.hcl

# Start Vault Server
nohup vault server -config=${VAULT_ENT_HOME}/config.hcl &
