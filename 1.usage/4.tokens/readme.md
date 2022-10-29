# Tokens

Tokens are the fundamental way of interacting with Vault. Can be issued through auth methods, operator command, or other tokens.

Tokens can be created from:
### Auth method
After you login using an authentication method, what you get is a token

### Parent token
You can use an existing token to generate a new child token

### Root token
Root tokens can do anything, so use it carefully. And They don't expire, so revoke them asap when you finish your piece of work.
Requires unseal or recovery keys to create. Should be revoked as soon as possible.

You can use them to:
- Initial setup
- When your main auth method is unavailable (for exaple AD)
- Emergency situation

# Tokens Properties
### Id
The value you use to execute actions against the vault server
### Accessor 
Only able to view the token properties except the ID + View the capabilities on a given path + Renew/Revoke a token
### Type 
Defines what type of token is
### Policies 
A token has policies associated to it
### TTL 
- creation_time: `1613828388 # Unix time 30m `
- creation_ttl: `30m # TTL set at creation`
- expire_time: `2021-02-20T09:09:48.4036711-05:00 # Project expiration time`
- explicit_max_ttl: `0s # Max TTL if set`
- issue_time: `2021-02-20T08:39:48.4036711-05:00 # Friendly time`
- ttl: `ttl 29m13s # TTL value`

### Orphaned 
Whether or not have a parent token. If it has a parent token and that one expires, the child token will expire as well.

# Token Types

| Service      | Batch |
| ----------- | ----------- |
| Fully featured, Heavyweight      | Limited featured, Lightweight       |
| Managed by accessor or ID      | Has no accessor       |
| Persistent in storage   | Not written to storage        |
| Calculated lifetime (renewable)   | Static lifetime (set on creation, no renewable)      |
| Can create child tockens   | No child tokens       |
| Default type   | Has to be explicitly created. Used for high-volume applications     |
| ID begins with "s."   | ID begins with "b."     |


*Note*: The root token is a service type token


# Usage

## Create a new token
vault token create [options]  
> vault token create –policy=my-policy –ttl=60m

## View token properties
vault token lookup [options] [ ACCESSOR | ID ]  
> vault token lookup -accessor <accessor_value>

## Check capabilities on a path
vault token capabilities TOKEN PATH  
> vault token capabilities <token_value> secrets/mykeys/

