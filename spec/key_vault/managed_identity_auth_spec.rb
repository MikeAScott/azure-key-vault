require 'spec_helper'
describe KeyVault::ManagedIdentityAuth do

  describe('#new') do
    it 'requires no parameters' do
      auth = KeyVault::ManagedIdentityAuth.new()
      expect(auth).not_to be_nil
    end
  end

  describe '.bearer_token' do
    subject(:auth) { KeyVault::ManagedIdentityAuth.new() }
    let(:auth_url) { "https://http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-04-02&resource=https://vault.azure.net/" }
    let(:access_token) { 'theaccesstoken' }
    let(:auth_response) { %Q[{
      "token_type":"Bearer",
      "some_other_params":"...",
      "resource":"https://vault.azure.net",
      "access_token":"#{access_token}"
    }] }

    let(:rest_request) do
      class_double('RestClient::Request')
        .as_stubbed_const(:transfer_nested_constants => true)
    end
    
    it 'authenticates with Microsoft OAUTH' do
      expect(rest_request).to receive(:execute).and_return(auth_response)
      auth.bearer_token
    end

    it 'raises argument error if bad request is returned' do
      expect(rest_request).to receive(:execute).and_raise(RestClient::BadRequest)
      expect{auth.bearer_token}.to raise_error(ArgumentError)
    end

    it 'raises custom Unauthorized exception if unauthorized' do
      expect(rest_request).to receive(:execute).and_raise(RestClient::Unauthorized)
      expect{auth.bearer_token}.to raise_error(KeyVault::Unauthorized)
    end

    it 'calls REST API get from the authentication url' do
      expect(rest_request).to receive(:execute)
         .with(hash_including(method: :get, url: auth_url))
          .and_return(auth_response)
      auth.bearer_token
    end 

    it 'returns the access_token as bearer token' do
      expect(rest_request).to receive(:execute).and_return(auth_response)
      expect(auth.bearer_token).to eq("Bearer #{access_token}")
    end

  end
end
