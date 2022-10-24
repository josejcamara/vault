# Tokens

Tokens can be created from:
### Auth method
After you login using an authentication method, what you get is a token

### Parent token
You can use an existing token to generate a new child token

### Root token
Root tokens can do anythig, so use it carefully. And They don't expire, so revoke them asap when you finish your piece of work

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
Time to Live
### Orphaned 
Whether or not have a parent token

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
