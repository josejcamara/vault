# Leases
One of the key features of dynamic secrets and tokens is the fact that they have a limited life time.  

Vault uses leases to control the life cycle of those dynamic secrets, by either renewing/extending their life time or revoking them.

All dynamic secrets and service tokens have a lease that determines how long they are valid for.

Lease duration can be extended by renewing the lease. Renewals cannot exceed the maximum TTL.

There is no direct CLI command. You need to use the `/sys/leases/lookup` path to look up the existing leases and their properties.

Revoking a token revokes all of its associated leases.


## Lease properties

- lease_id
- lease_duration
- lease_renewable

## Working with leases
Renewals are based on the current time, and not the creation time. So, renew for 30m will will set the value from the time you run the command. Still nee to be kept less than max TTL.


When you ask for revocation, vault will first revoke the lease and then will queue the request to the secret engine to actually delete whatever that secret is (makes sense for external secret engines).

We have prefix revocation to remove in bulk, in case a security breach. It requires sudo permissions as it's very powerful and needs to be taken carefully.

- Renew a lease
> vault lease renew [options] ID

- Revoke a lease before it expires
> vault lease revoke [options] ID

- Lookup active leases
> vault list [options] sys/leases/lookup/PATH 

- View leases properties
> vault write [options] sys/leases/lookup/ lease_id=ID