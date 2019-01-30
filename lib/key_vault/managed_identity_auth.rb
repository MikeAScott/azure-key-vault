require 'rest-client'
require 'json'
module KeyVault
  # Authenticator for Azure Key Vault using Managed Identity
  class ManagedIdentityAuth
    # Create authenticator using Managed Identity
    # ==== Parameters:
    # +api_version+:: (*optional*) Version of the azure Metadata REST API to use.
    #                 Defaults to +METADATA_API_VERSION+
    def initialize(api_version: METADATA_API_VERSION)
      @api_version = api_version || METADATA_API_VERSION
    end

    # Authenticates with Azure using OAUTH 2.0
    # ==== Returns:
    # A string containing the bearer token for insertion into request headers
    # ==== Raises:
    # +ArgumentError+:: If the authentication request format is invalid
    # +KeyVault::Unauthorized+:: If authentication fails authorization
    def bearer_token
      result = RestClient::Request.execute(method: :get,
                                           url: url,
                                           headers: headers)
      token_resp = JSON.parse(result)
      "Bearer #{token_resp['access_token']}"
    rescue RestClient::BadRequest
      raise ArgumentError, 'Could not authenticate to Azure (Bad Request)'
    rescue RestClient::Unauthorized
      raise KeyVault::Unauthorized
    end

    private

    def headers
      { 'Metadata' => 'true' }
    end

    def url
      "https://http://169.254.169.254/metadata/identity/oauth2/token?api-version=#{@api_version}&resource=https://vault.azure.net/"
    end
  end
end
