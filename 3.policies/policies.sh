#!/bin/bash

# Multiple options for assignment (Token, identity, auth methods)
# The most specific path wins
# No internal versioning for a policy
# Special policies:
#   - Default policy: Created when creating the instance. It can be edited. It can NOT be deleted (https://www.vaultproject.io/docs/concepts/policies#default-policy)
#   - Root policy: Automatically associated with root tokens. Can be assigned to other tokens. Can NOT be edited or deleted (https://www.vaultproject.io/docs/concepts/policies#root-policy)

# Format HCL or JSON

### Paths 

# Two wildcards available

#   - Using the glob '*' at the end of the path
# Matches "secret/mypath/web1/" and "secret/mypath/webapp/apikeys"
# path "secret/mypath/web*"

#   - Using the path segment match '+'
# Matches "secret/mypath/web1/apikeys" and "secret/mypath/web2/apikeys"
# path "secret/mypath/+/apikeys"

# Also use of parameters is available with in a path

#   - Resolve to the name of the entity
# Allows any path in that entity
# path "secret/{{identity.entity.name}}/*"

### Capabilities  
#   - CRUD (Create, Read, Update, Delete)
#   - List (only enumerate, not read) 
#   - Sudo
#   - Deny (overrides all other actions)

# Allow full access to the apikey in mypath
# path "secret/mypath/+/apikey" {
#     capabilities = ["create", "read", "update", "delete"]
# }

# Deny access to the mypath myprivate path
# path "secret/mypath/webapp/*" {
#     capabilities = ["create", "read", "update", "delete"]
# }
# path "secret/mypath/webapp/myprivate*" {
#     capabilities = ["deny"]
# }


### Actions

# Create a policy
# vault policy write [options] policy_name [file_path | <stdin>]
vault policy write secrets-management policies_manage_secrets.hcl
vault policy list
vault policy read secrets-management

# Format per Hashicorp guidelines
# vault policy fmt [options] file_path
vault policy fmt secrets-management

# Delete
# vault policy delete [options] policy_name
vault policy delete secrets-management


### Assigment
# Directly on token when created
#   - vault token create -policy="secrets-management"

# Applied through an authentication method
#   - vault write auth/userpass/users/jose token_policies="secrets-management"

# Assigned to an entity inside the identity secrets engine
#   - vault write identity/entity/name/jose policies="secrets-management"