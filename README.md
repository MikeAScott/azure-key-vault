# azure-key-vault

[![Gem Version](https://badge.fury.io/rb/azure-key-vault.svg)](https://badge.fury.io/rb/azure-key-vault)

Ruby wrapper for Azure Key Vault REST API

## Examples

### Get an access token
`bearer_token = KeyVault::Auth.new(tenant_id, client_id, client_secret).bearer_token`

### Get an access token using Managed Identity
`bearer_token = KeyVault::ManagedIdentityAuth.new().bearer_token`

### Get client for and existing Azure Key Vault
`vault = KeyVault::Client.new(vault_name, bearer_token)`

or

`vault = KeyVault::Client.new(vault_name, bearer_token, api_version: '<other _api_version>')`

### Get the most recent version of a secret
`vault.get_secret(secret_name)`

### Get a specific version of a secret
`vault.get_secret(secret_name, secret_version)`
