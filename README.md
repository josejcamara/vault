# HashiCorp Vault
HashiCorp Vault is an open source secrets management tool specifically designed to control access to sensitive credentials in a low-trust environment.  
It can be used to store sensitive values and at the same time dynamically generate access for specific services/applications on lease.  
It provides full lifecycle management of static and dynamic secrets.  

More details in https://www.vaultproject.io/docs/what-is-vault

## Tutorials
- https://learn.hashicorp.com/vault

## Certification Details
- https://www.hashicorp.com/certification/vault-associate

## Vault binary
- Windows – use Chocolatey
> choco install vault

-  Mac – use Homebrew
> brew tap hashicorp/tap
> brew install hashicorp/tap/vault

- Linux – use your package manager
> curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add –  
> sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" sudo apt-get update && sudo apt-get install vault

## Running Vault for Development
This runs a completely in-memory Vault server, which is useful for development but should not be used in production.  
- Running on localhost without SSL 
- In-memory storage (when you shut it down, whatever you store in Vault will go)
- Starts unsealed (for being used straight away)
- UI enabled
- Key/Value secrets engine enabled

It can be run with docker:

> docker run --cap-add=IPC_LOCK -d --name=dev-vault vault  

or using the vault binary

> vault server -dev

You can also start the server using configuration files from a directory:
> vault server -dev -config /etc/vault
