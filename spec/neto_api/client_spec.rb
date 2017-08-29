require_relative '../spec_helper'

describe NetoApi::Client do
  describe '#connection' do
    it 'gives active connection' do
      client = NetoApi::Client.new('https://mystore.neto.com.au/', 'random-key',
                                   headers: { 'NETOAPI_ACTION' => 'GetItem' })

      connection = client.connection
      expect(connection).not_to be_nil

      expect(connection.url_prefix.to_s).to eq 'https://mystore.neto.com.au/'
      headers = connection.headers
      expect(headers['User-Agent']).to eq NetoApi::Client::USER_AGENT
      expect(headers['NETOAPI_ACTION']).to eq 'GetItem'
      expect(headers['NETOAPI_KEY']).to eq 'random-key'
      expect(headers['Content-type']).to eq 'application/json'.freeze
      expect(headers['Accept']).to eq 'application/json'.freeze
    end
  end
end
