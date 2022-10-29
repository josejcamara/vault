#!/bin/bash

# Run vault-dev
vault server -dev

# You can also start the server using configuration files from a directory:
vault server -dev -config /etc/vault

# Log into Vault (use the root token)
export VAULT_ADDR=http://127.0.0.1:8200
vault login 


# ============================
# List Auth Methods enabled
# ============================
vault auth list


# ============================
# Help Auth Methods
# ============================
vault path-help auth/userpass/
vault path-help auth/userpass/users
vault path-help auth/userpass/users/something
