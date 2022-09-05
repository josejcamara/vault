#!/bin/bash

# =====================
# Enable Auth Methods 
# =====================

# Now set your Vault address environment variable
export VAULT_ADDR=http://127.0.0.1:8200

# Log into Vault (use the root token)
vault login 

# See auth methods avilable
vault auth list

# Enable first auth method using userpass
vault auth enable userpass

# Enable AppRole as well (can try using the UI)
vault auth enable -description="Demo AppRole" approle
vault auth list

# Fix description
vault auth tune -description="Demo Userpass" userpass/
vault auth list
