class LineItem

  def add_shopify_obj shopify_li, shopify_api
    @shopify_id = shopify_li['id']
    @shopify_product_id = shopify_li['product_id']
    @name = shopify_li['name']
    @quantity = shopify_li['quantity'].to_i
    @price = shopify_li['price']
    
    self
  end
  
  def wombat_obj
    [
      {
        'id' => @shopify_id,
        'product_id' => @shopify_product_id,
        'name' => @name,
        'quantity' => @quantity,
        'price' => @price
      }      
    ]
  end
      
end