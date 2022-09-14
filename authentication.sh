#!/bin/bash

# Run vault-dev
vault server -dev

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


# ============================
# Enable Auth Methods 
# ============================
# > vault auth enable [options] TYPE
# Multiple instances of the same method can be enabled on different paths (default path = method's name)

# Enable first auth method using userpass
vault auth enable userpass
vault auth list
vault auth enable -path=group1_pass userpass

# Enable AppRole as well (can try using the UI)
vault auth enable -description="Demo AppRole" approle
vault auth list


# ============================
# Tune/Configure Auth Methods 
# ============================
# > vault auth tune [options] PATH

# Tune description
vault auth tune -description="Demo Userpass" userpass/
vault auth list

# Create a new user
vault write auth/userpass/users/jose password=jose

# Create a role
vault write auth/approle/role/cicd role_name="integration" secret_id_num_uses=1 secret_id_tll=1h


# ============================
# Use Auth Methods 
# ============================

# Login using token
vault login

# Login with an userpass
# > vault login [options] AUTH -OR- vault write [options] PATH DATA
vault login -method=userpass username=jose
# > it prompts for the password
# OR
vault write auth/userpass/login/jose password=jose

# Login with approle
# > vault path-help auth/approle/login
roleId=`vault read -field=role_id auth/approle/role/cicd/role-id` 
secretId=`vault write -field=secret_id -force auth/approle/role/cicd/secret-id`

vault write auth/approle/login role_id=$roleId secret_id=$secretId

# Same login but with the API
curl --request POST \
    --data "{\"role_id\": \"$roleId\", \"secret_id\": \"$secretId\"}" \
    $VAULT_ADDR/v1/auth/approle/login | jq


# ============================
# Disable Auth Methods 
# ============================
# > vault auth disable [options] PATH

# ** WARNING **: Disabling a method also deletes all the information stored about that method
vault auth disable userpass
vault auth list
