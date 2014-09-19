class LineItem

  attr_reader :sku

  def add_shopify_obj shopify_li, shopify_api
    @shopify_id = shopify_li['id']
    @shopify_parent_id = shopify_li['product_id']
    @sku = shopify_li['sku']
    @name = shopify_li['name']
    @quantity = shopify_li['quantity'].to_i
    @price = shopify_li['price'].to_f

    self
  end

  def wombat_obj
    [
      {
        'product_id' => @sku,
        'shopify_id' => @shopify_id.to_s,
        'shopify_parent_id' => @shopify_parent_id.to_s,
        'name' => @name,
        'quantity' => @quantity,
        'price' => @price
      }
    ]
  end

end
