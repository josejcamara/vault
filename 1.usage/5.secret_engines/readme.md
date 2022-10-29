# Secrets Engines
Secrets engines are plugins used by Vault to handle sensitive data.  
[Official guide](https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-secrets-engines)

## How do secret engines handle sensitive data

| Store       | Generate    | Encrypt    |
| ----------- | ----------- |----------- |
| Sensitive data is stored securely by Vault  | Vault generates and manages sensitive data  | Vault provides encryption services for existing data |
| Data that exists our of vault | Usually interacting with a external service |  Data that exists out of vault |
| Vault manages access to that data |  | |

## Secrets Engine Categories (non-official)

- `Cloud`: AWS, Azure, GCP
- `Database`: MSSQL, Postgresql, MySql
- `Vault-Internal`: Key-Value, Identity
- `Identity`: AD, OpenLDAP
- `Certificate`: SSH, PKI
- `Tokens`: Consul, Nomad
- `Encryption`: Transit

## Dynamic vs. Static Secrets

### Static secrets
- Store existing data securely
- Manual lifecycle management 
- Example: Key/Value engine
### Dynamic secrets
- Generate data on demand
- Lease issued for each secret (who long valid for)
- Automatic lifecycle management - Majority of secrets engines
- Example: database engine

## Secrets Engine Lifecycle
- `Enable`: Mount an instance of the plugin in the path we indicate
- `Tune`: Tune the settings once it was enabled
- `Configure`: Internal configuration for the plugin
- `Move`: The path can me moved after creation
- `Disable`: It does delete all the information stored. BE CAUTIOUS!

## Configuring Secrets Engines
- All engines are enabled on `/sys/mounts` 
- Engines are enabled on a path (Defaults to engine name)
- Engines can be moved, but with some downsides:
    - Revokes all existing leases 
    - May impact policies, since they are based in the path
- Engines can be tuned and configured
    - *Tuning* settings are common for all engines
    - *Configuration* settings are specific to an engines

## Working with Secrets Engines
- List existing secrets engines
> vault secrets list

- Enable a new secrets engine
> `vault secrets enable` [options] TYPE  
> vault secrets enable –path=MyKV kv

- Tune a secrets engine setting
> `vault secrets tune` [options] PATH  
> vault secrets tune –description="Example KV" MyKV

- Move an existing secrets engine
> `vault secrets move` [options] SOURCE DEST 
> vault secrets move MyKV MyKV1

- Disable a secrets engine
> `vault secrets disable` [options] PATH  
> vault secrets disable MyKV1

## Interacting with a Secret Engine
- Authenticate to get back a policy
- Access through CLI, UI, or API
- Most engines use standard commands - `read`, `list`, `write`, and `delete`
- *Exception*: Key Value uses `vault kv` subset of commands
    - Mostly directed to v2
    - K/V version 1 can use standard commands


## Response Wrapping (cubbyhole)
Response wrapping creates a cubbyhole to store data and a single-use token to retrieve it.

### Request wrapping for any command
Generate token I can pass to whatever entity I want to retrieve the information
> vault command –wrap-ttl=\<duration> PATH

### Unwrap using the issued token
On the entity side (no need to login)
> vault unwrap [options] [TOKEN]