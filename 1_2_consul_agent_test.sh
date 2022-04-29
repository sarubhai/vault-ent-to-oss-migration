#!/bin/bash
# Name: 1_2_consul_agent_test.sh
# Owner: Saurav Mitra
# Description: Test & Validate Consul Agent Server to be used as Vault Storage Backend
# Test UI: https://127.0.0.1:8501/ui/

source ~/.bash_profile
cd ${CONSUL_OSS_HOME}

export CONSUL_HTTP_ADDR=https://127.0.0.1:8501
export CONSUL_CACERT=${CONSUL_OSS_HOME}/consul-agent-ca.pem
export CONSUL_CLIENT_CERT=${CONSUL_OSS_HOME}/dc1-server-consul-0.pem
export CONSUL_CLIENT_KEY=${CONSUL_OSS_HOME}/dc1-server-consul-0-key.pem

consul members
consul operator raft list-peers
# Create a snapshot:
consul snapshot save consul-backup.snap
# Inspect a snapshot:
consul snapshot inspect consul-backup.snap
