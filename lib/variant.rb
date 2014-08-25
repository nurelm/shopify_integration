class Variant
  
  attr_reader :shopify_id, :sku, :price, :options, :shipping_category, :name

  def add_shopify_obj shopify_variant, shopify_options
    @shopify_id = shopify_variant['id']
    @name = shopify_variant['title']
    @sku = shopify_variant['sku']
    @price = shopify_variant['price']
    @shipping_category = shopify_variant['requires_shipping'] ? 'Shipping Required' : 'Shipping Not Required'
    
    @options = Hash.new
    shopify_variant.keys.grep(/option\d*/).each do |option_name|
      if !shopify_variant[option_name].nil?
        option_position = option_name.scan(/\d+$/).first.to_i
        real_option_name = shopify_options.select {|option| option['position'] == option_position }.first['name']
        @options[real_option_name] = shopify_variant[option_name]
      end
    end
  end
  
  def add_wombat_obj wombat_variant
    @price = wombat_variant['price']
    @sku = wombat_variant['sku']
    @options = Hash.new
    wombat_variant['options'].values.each_with_index do |value, index|
      @options['option' + (index + 1).to_s] = value
    end
  end
  
  def shopify_obj
    {
      "price" => @price,
      "sku" => @sku
    }.merge(@options)
  end

end