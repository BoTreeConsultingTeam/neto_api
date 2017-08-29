require_relative '../spec_helper'

describe NetoApi::Product do
  describe '#all' do
    it 'returns all products' do
      VCR.use_cassette 'products' do
        product = NetoApi::Product.new('https://amits-assorted.neto.com.au', '3RqSqZ384PtUNh9Im6A0bAG9FdGbmq0j')
        response = product.all
        expect(response.status).to eq 200
        expect(response.body).not_to be_nil
      end
    end
  end
end
