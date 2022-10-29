# First of all we are going to start Vault in development mode
vault server -dev

# In a separated terminal
# Set your Vault address environment variable
export VAULT_ADDR=http://127.0.0.1:8200

# Set the root token variable
root_token=<ROOT_TOKEN_VALUE>

# And log into Vault using the root token
vault login $root_token

# Use consul secrets engine as example
# --------
vault secrets enable consul

# Get consul up and running
mkdir data
consul agent -bootstrap -config-file="consul-config.hcl" -bind="127.0.0.1"
consul acl bootstrap
export CONSUL_HTTP_TOKEN=SECRETID_VALUE
consul acl policy create -name=web -rules @web-policy.hcl

# Now we'll configure out Consul secrets engine
vault write consul/config/access address="http://127.0.0.1:8500" token=$CONSUL_HTTP_TOKEN
vault write consul/roles/web name=web policies=web ttl=3600 max_ttl=7200
# --------

# And finally generate a bunch of leases to work with (x4)
vault read consul/creds/web
vault read consul/creds/web
vault read consul/creds/web
vault read consul/creds/web

# Let's renew one of the leases for 30 minutes
vault lease renew -increment=30m LEASE_ID
# The duration hase actually been shorten!! It was 1h (ttl=3600) but the renew takes from the current time

# Now get the properties of the lease
vault write sys/leases/lookup lease_id=LEASE_ID

# What if we exceed the lease max ttl?
vault lease renew -increment=120m LEASE_ID
# No error, but a warning and set the value to the maximun

# Now we can try and revoke one of the leases
# First we'll get a list of active leases
vault list sys/leases/lookup/consul/creds/web/

# Now revoke the lease (notice the word 'queued')
vault lease revoke LEASE_ID

# Confirm our lease is gone
vault list sys/leases/lookup/consul/creds/web/

# What if we want to revoke all of them? Prefix time
vault lease revoke -prefix consul/creds/web/

# Confirm that all the leases are gone
vault list sys/leases/lookup/consul/creds/web/
# ERROR: No value found at sys/leases/lookup/consul/creds/web/ as we have removed them
