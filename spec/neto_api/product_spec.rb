require_relative '../spec_helper'

describe NetoApi::Product do
  describe '#all' do
    it 'returns all products' do
      VCR.use_cassette 'products' do
        product = NetoApi::Product.new('https://amits-assorted.neto.com.au', '3RqSqZ384PtUNh9Im6A0bAG9FdGbmq0j')
        NetoApi::Product.default_filters['Filter']['Limit'] = 10
        products = product.all
        expect(products.length).to eq 18
        expect(products.first).to be_kind_of ::Product
      end
    end
  end
end
