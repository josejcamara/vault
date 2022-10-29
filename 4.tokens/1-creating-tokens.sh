# First of all we are going to start Vault in development mode
vault server -dev

# In a separated terminal
# Set your Vault address environment variable
export VAULT_ADDR=http://127.0.0.1:8200

# Set the root token variable
root_token=<ROOT_TOKEN_VALUE>

# And log into Vault using the root token
vault login $root_token

# First we are going to create a basic token
# Use the -policy to avoid having created another root token
vault token create -policy=default -ttl=60m -explicit-max-ttl=72h

# Now let's check out some info on the token
vault token lookup <TOKEN_VALUE>

# We can do the same using the accessor, but no ID
vault token lookup -accessor ACCESSOR_VALUE
 
# Renew a token
vault login <TOKEN_VALUE>
vault token renew -increment=48h

# Now let's revoke our token
vault token revoke -accessor ACCESSOR_VALUE
