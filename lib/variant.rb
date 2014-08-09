class Variant
  
  attr_reader :shopify_id, :sku, :price, :options, :shipping_category, :name

  def add_shopify_obj shopify_variant
    @shopify_id = shopify_variant['id']
    @name = shopify_variant['title']
    @sku = shopify_variant['sku']
    @price = shopify_variant['price']
    @shipping_category = shopify_variant['requires_shipping'] ? 'Shipping Required' : 'Shipping Not Required'
    
    @options = Hash.new
    shopify_variant.keys.grep(/option\d*/).each do |option_name|
      @options[option_name] = shopify_variant[option_name]
    end
  end

end