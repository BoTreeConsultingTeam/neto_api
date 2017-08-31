require 'neto_api/base'
require 'product'

module NetoApi
  class Product < Base

    def all(filters = DEFAULT_FILTERS)
      items(filters).inject([]) do |list, item|
        list << ::Product.new.tap do |p|
          p.sku = item['SKU']
          p.product = item['Name']
          p.description = item['Description']
          p.image_url = item['ImageURL']
          p.url = item['ItemURL']
          set_category(p, item)
          p.brand = item['Brand']
          p.gtin = item['UPC'] || item['UPC1']
          set_stock_amount(p, item)
          p.stock_available = p.stock_amount > 0
        end
      end
    end

    def self.default_filters
      DEFAULT_FILTERS
    end

    private

    def items(filters)
      all_items = []
      page = 0

      loop do
        filters['Filter']['Page'] = page
        items = post('GetItem', filters).body['Item']
        break if items.length.zero?

        all_items << items
        page += 1
      end

      all_items.flatten
    end

    DEFAULT_FILTERS = {
      'Filter' => {
        'IsActive' => ['True'].freeze,
        'Approved' => ['True'].freeze,
        'Limit' => 250,
        'OutputSelector' => %w[SKU Name Description ImageURL ProductURL Categories Brand UPC WarehouseQuantity DefaultPrice].freeze
      }
    }

    DC_CATEGORY_ELEMENTS = %w[first_category second_category third_category fourth_category fifth_category].freeze

    def set_category(product, item)
      categories = item.fetch('Categories').first['Category']
      if categories.is_a? Array
        categories.sort_by! { |c| -c['Priority'].to_i }
          .each_with_index do |c, index|
            product.send("#{DC_CATEGORY_ELEMENTS[index]}=".to_sym, c['CategoryName'])
          end
      else
        product.first_category = categories['CategoryName'] if categories
      end
    end

    def set_stock_amount(product, item)
      warehouse_quantity = item['WarehouseQuantity']
      if warehouse_quantity.is_a? Array
        product.stock_amount = warehouse_quantity.inject(0) { |sum, item| sum += item['Quantity'].to_i }
      else
        product.stock_amount = item['WarehouseQuantity']['Quantity'].to_i
      end
    end
  end
end