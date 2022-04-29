#!/bin/bash
# Name: 2_1_vault_server_with_consul_storage_start.sh
# Owner: Saurav Mitra
# Description: Configure & Start Vault Enterprise Server with Consul Storage Backend

source ~/.bash_profile
cd ${VAULT_ENT_HOME}

# Vault Config
tee ${VAULT_ENT_HOME}/config-consul.hcl &>/dev/null <<EOF
storage "consul" {
    address = "127.0.0.1:8501"
    path = "vault/"
    # token = "CONSUL_VAULT_TOKEN"
    scheme = "https"
    tls_ca_file   = "${CONSUL_OSS_HOME}/consul-agent-ca.pem"
    tls_cert_file = "${CONSUL_OSS_HOME}/dc1-server-consul-0.pem"
    tls_key_file  = "${CONSUL_OSS_HOME}/dc1-server-consul-0-key.pem"
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

# Start Vault Server
nohup vault server -config=${VAULT_ENT_HOME}/config-consul.hcl &
