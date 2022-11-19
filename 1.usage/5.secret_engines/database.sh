# TO REVIEW
# >> https://developer.hashicorp.com/vault/docs/secrets/databases
# >> https://developer.hashicorp.com/vault/docs/secrets/databases/postgresql

# For PostgreSQL
CREATE USER vaultuser WITH PASSWORD 'vaultpass';
ALTER USER vaultuser WITH SUPERUSER;

# For Vault
## SETUP
# 1. Enable the database secrets engine if it is not already enabled:
vault secrets enable database

# 2. Configure Vault with the proper plugin and connection information:
vault write database/config/my-postgresql-database \
    plugin_name="postgresql-database-plugin" \
    allowed_roles="my-role" \
    connection_url="postgresql://{{username}}:{{password}}@localhost:5432/database-name" \
    username="vaultuser" \
    password="vaultpass"

# 3. Configure a role that maps a name in Vault to an SQL statement to execute to create the database credential:
# (It runs every time someone request privileges)
vault write database/roles/my-role \
    db_name="my-postgresql-database" \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    default_ttl="1h" \
    max_ttl="24h"

## USAGE
vault read database/creds/my-role

Key                Value
---                -----
lease_id           database/creds/my-role/2f6a614c-4aa2-7b19-24b9-ad944a8d4de6
lease_duration     1h
lease_renewable    true
password           SsnoaA-8Tv4t34f41baD
username           v-vaultuse-my-role-x

