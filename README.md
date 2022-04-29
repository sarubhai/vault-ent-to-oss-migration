## Vault Enterprise to Vault OSS Migration

Simulate the migration of Vault Enterprise v1.5.7 with Consul OSS v1.8.9 as storage backend to Vault OSS v1.10.0 with Raft Integrated storage backend.

### Execution Order

```
./0_setup.sh
./1_1_consul_agent_start.sh
./1_2_consul_agent_test.sh
./2_1_vault_server_with_consul_storage_start.sh
./2_2_vault_server_with_consul_storage_initial_setup.sh
./3_1_vault_server_with_integrated_storage_migrate.sh
./3_2_vault_server_with_integrated_storage_test.sh
./4_1_vault_oss_server_with_integrated_storage_start.sh
./4_2_vault_oss_server_with_integrated_storage_restore.sh
./5_cleanup.sh
```
