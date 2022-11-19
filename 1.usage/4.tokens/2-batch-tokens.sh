# Make sure you're logged in as the root token
vault login $root_token

# Create a batch token with a ttl of 30m
vault token create -type=batch -policy=default -ttl=30m
# Look at that looong id, starting with "b."
batch_id=BATCH_TOKEN_ID

# Let's try to lookup the properties of a batch token
vault token lookup $batch_id
# accessor: n/a (batch tokens have none of those)
# renewable: false
# type: batch

# If you try to renew it
vault token renew $batch_id
# > ERROR: batch tokens cannot be renewed
