class Variant
  
  attr_reader :shopify_id, :sku, :price, :option1, :option2, :option3, :shipping_category, :name

  def add_shopify_obj shopify_variant
    @shopify_id = shopify_variant['id']
    @name = shopify_variant['title']
    @sku = shopify_variant['sku']
    @price = shopify_variant['price']
    @option1 = shopify_variant['option1']
    @option2 = shopify_variant['option2']
    @optionr3 = shopify_variant['option3']
    @shipping_category = shopify_variant['requires_shipping'] ? 'Shipping Required' : 'Shipping Not Required'
  end

end