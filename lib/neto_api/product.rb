require 'neto_api/base'

module NetoApi
  class Product < Base

    def all(filters = DEFAULT_FILTERS)
      post('GetItem', filters)
    end

    private

    DEFAULT_FILTERS = {
      'Filter' => {
        'IsActive' => ['True'],
        'Approved' => ['True'],
        'OutputSelector' => %w[SKU Name Description ImageURL ProductURL Categories Brand UPC WarehouseQuantity DefaultPrice].freeze
      }
    }
  end
end