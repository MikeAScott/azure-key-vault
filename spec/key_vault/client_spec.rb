require 'spec_helper'
describe KeyVault::Client do
  subject(:client) { KeyVault::Client.new(vault_name, bearer_token) }
  let(:vault_name) { 'the-vault' }
  let(:bearer_token) { 'Bearer tokenvalue' }

  describe '#new' do
    it 'requires vault_name and bearer_token' do
      client = KeyVault::Client.new(vault_name, bearer_token)
      expect(client).not_to be_nil
    end

    it 'defaults api_version' do
      client = KeyVault::Client.new(vault_name, bearer_token)
      expect(client.api_version).to eq KeyVault::VAULT_API_VERSION
    end

    it 'allows setting of api_version' do
      client = KeyVault::Client.new(vault_name, bearer_token,
                                    api_version: '2015-06-01')
      expect(client.api_version).to eq '2015-06-01'
    end
  end

  describe '.get_secret' do
    let(:secret_name) { 'the-secret' }
    let(:secret_value) { 'top secret' }
    let(:api_version) { KeyVault::VAULT_API_VERSION }
    let(:secret_url) { "https://#{vault_name}.vault.azure.net/secrets/#{secret_name}?api-version=#{api_version}" }
    let(:valid_response) do
      <<-RESPONSE
      {
        "value": "#{secret_value}",
        "contentType": "String",
        "id": "https://#{vault_name}.vault.azure.net/secrets/#{secret_name}/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        "attributes": {
          "enabled": true,
          "created": 1512680041,
          "updated": 1512680041,
          "recoveryLevel": "Purgeable"
        }
      }
      RESPONSE
    end
    let(:rest_request) do
      class_double('RestClient')
        .as_stubbed_const(transfer_nested_constants: true)
    end

    context 'when secret_version is not supplied' do
      it 'requests GET from secret url' do
        expect(rest_request).to receive(:get)
          .with(secret_url, 'Authorization' => bearer_token )
          .and_return(valid_response)
        client.get_secret secret_name
      end

      it 'returns secret value from response' do
        expect(rest_request).to receive(:get)
          .and_return(valid_response)
        returned_secret = client.get_secret secret_name
        expect(returned_secret).to eq secret_value
      end

      it 'returns nil if secret not found' do
        expect(rest_request).to receive(:get).and_raise(RestClient::NotFound)
        returned_secret = client.get_secret 'not-a-secret'
        expect(returned_secret).to be_nil
      end

    end

    context 'when secret_version is supplied' do
      let(:secret_version) { 'abcdef' }
      let(:secret_url) { "https://#{vault_name}.vault.azure.net/secrets/#{secret_name}/#{secret_version}?api-version=#{api_version}" }
      it 'requests that version of the secret' do
        expect(rest_request).to receive(:get)
          .with(secret_url, 'Authorization' => bearer_token)
          .and_return(valid_response)
        client.get_secret(secret_name, secret_version)
      end
    end

    context 'when secret name has non alphanumerics' do
      let(:secret_name_with_invalid_chars) { 'a secret::with!#&$chars-and-1234567890' }
      let(:secret_name) { 'a-secret--with----chars-and-1234567890' }
      it 'translates them to and spaces to hyphens' do
        expect(rest_request).to receive(:get)
          .with(secret_url, 'Authorization' => bearer_token)
          .and_return(valid_response)
        client.get_secret secret_name_with_invalid_chars
      end
    end


  end
end
