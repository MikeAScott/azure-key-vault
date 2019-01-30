require 'key_vault/version'
require 'key_vault/client'
require 'key_vault/auth'
require 'key_vault/managed_identity_auth'

# Provides a simple Ruby interface for the Azure Key Vault REST API
module KeyVault
  # The default Azure REST API version
  VAULT_API_VERSION = '2016-10-01'.freeze
  METADATA_API_VERSION = '2018-04-02'.freeze
end
