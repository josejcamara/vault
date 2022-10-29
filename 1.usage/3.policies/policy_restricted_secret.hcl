# Allow access to all mysecret data
path "mysecret/data/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}

# Allow access to metadata 
path "mysecret/metadata/*" {
    capabilities = ["list"]
}

# Deny access to my_eyes_only mysecret data
path "mysecret/data/apitokens/my_eyes_only*" {
    capabilities = ["deny"]
}

path "mysecret/metadata/apitokens/my_eyes_only*" {
    capabilities = ["deny"]
}