# Key Value Engine Versions
# Version 1
#   No versioning, last key wins 
#   Faster with fewer storage calls 
#   Deleted items are gone 
#   Can be upgraded to version 2 
#   Default version on creation
# Version 2
#   Versioning of past secrets
#   Possibly less performant
#   Deleted items and metadata retained 
#   Cannot be downgraded
#   Can be specified at creation
#
#  Both of them working, choose one depending of your situation
#

# Start Vault in development mode
vault server -dev

# In a separated terminal
# Set your Vault address environment variable
export VAULT_ADDR=http://127.0.0.1:8200
# Set the root token variable
root_token=ROOT_TOKEN_VALUE
# And log into Vault using the root token
vault login $root_token

# First see which secrets engines are enabled
vault secrets list
# cubbyhole: enabled by default
# identity: enabled by default
# secret: enable by default on a dev server, on v2
# sys: Just for system management. not for interacting with it


# Start with enabling a new K/V engine
vault secrets enable -path=MyKV -version=2 kv

# If we want to configure some settings for MyKV, this shows all the setting available
vault path-help /sys/mounts/MyKV

# So, for adding a description, we use "tune"
vault secrets tune -description="Globomantics K/V version 2" MyKV

# Check the current settings
vault read MyKV/config
# Set the max_versions to 5
vault write MyKV/config max_versions=5


# Writing a secret value
# vault kv put [options] KEY [DATA K=V]
vault kv put MyKV/apikeys/myService token=123456

# Listing secret keys
# vault kv list [options] PATH 
vault kv list MyKV/apikeys/

# Reading a secret value with a specific version
# vault kv get [options] KEY
vault kv get –version=1 MyKV/apikeys/myService

# Deleting a value (does not permanently destroy de value)
# vault kv delete [options] KEY
vault kv delete –versions=1 MyKV/apikeys/myService

# Don't worry it's not really gone
vault kv metadata get MyKV/apikeys/myService

# We can recover it by doing the following
vault kv undelete -versions=1 MyKV/apikeys/myService

# Destroying a value
# vault kv destroy [options] KEY
vault kv destroy –versions=1 MyKV/apikeys/myService

# Check again
vault kv metadata get MyKV/apikeys/myService
# The reference is still there, but the value is gone!

# We can delete everything by deleting the metadate too
vault kv metadata delete MyKV/apikeys/myService


# What about using the API instead of the CLI?

# Make sure you have the root token stored in $root_token
curl --header "X-Vault-Token: $root_token" \
  $VAULT_ADDR/v1/MyKV/data/apikeys/myService | jq

# If we want a specific version, we can add a query string
curl --header "X-Vault-Token: $root_token" \
  $VAULT_ADDR/v1/MyKV/data/apikeys/myService?version=1 | jq



# If you want to retrieve a secret and response wrap it

# First we'll do it using a secret in the MyKV store
vault kv get -wrap-ttl=30m MyKV/apikeys/myService

# Now we can use the wrapping token value to read the value
vault unwrap WRAPPING_TOKEN_ID

# If we lookup the token after using it, it's gone!
vault token lookup WRAPPING_TOKEN_ID

