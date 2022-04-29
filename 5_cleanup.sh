#!/bin/bash
# Name: 5_cleanup.sh
# Owner: Saurav Mitra
# Description: Clean up the PoC setup

source ~/.bash_profile
kill -9  `ps | grep consul.hcl | grep -v grep | awk '{ print $1 }'`
kill -9  `ps | grep config.hcl | grep -v grep | awk '{ print $1 }'`

sleep 5

rm -rf ${VAULT_POC_HOME}/variables
rm -rf ${VAULT_POC_HOME}/consul
rm -rf ${VAULT_POC_HOME}/vault
