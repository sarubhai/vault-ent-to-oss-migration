#!/bin/bash
# Name: 1_1_consul_agent_start.sh
# Owner: Saurav Mitra
# Description: Configure & Start Consul Agent Server to be used as Vault Storage Backend
# https://learn.hashicorp.com/tutorials/consul/deployment-guide?in=consul/production-deploy

source ~/.bash_profile
cd ${CONSUL_OSS_HOME}

consul keygen > gossip_encryption_key.txt
gossip_encryption_key=`cat gossip_encryption_key.txt`
consul tls ca create
consul tls cert create -server
sleep 5

# Consul Config
tee ${CONSUL_OSS_HOME}/consul.hcl &>/dev/null <<EOF
datacenter = "dc1"
data_dir = "${CONSUL_OSS_HOME}/data"
bind_addr = "127.0.0.1"
log_level = "INFO"
retry_join = ["127.0.0.1:8301"]

performance = {
    raft_multiplier = 1
}

verify_incoming = false
verify_outgoing = false
verify_server_hostname = false

auto_encrypt = {
    allow_tls = true
}

ca_file = "${CONSUL_OSS_HOME}/consul-agent-ca.pem"
cert_file = "${CONSUL_OSS_HOME}/dc1-server-consul-0.pem"
key_file = "${CONSUL_OSS_HOME}/dc1-server-consul-0-key.pem"

ports = {
    http = -1
    https = 8501
}

server = true
bootstrap_expect = 1
ui = true
encrypt = "${gossip_encryption_key}"
EOF

# Start Consul Agent Server
nohup consul agent -config-file=${CONSUL_OSS_HOME}/consul.hcl &
