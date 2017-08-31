# Value Object representing Dynamic Creative's Feed attributes
class Product
  attr_accessor :sku, :product, :description, :url, :image_url, :brand, :gtin, :stock_amount, :stock_available,
                :first_category, :second_category, :third_category, :fourth_category, :fifth_category


  def initialize(params = {})
    params.keys.each do |key|
      instance_variable_set("@#{key}", params[key])
    end
  end
end