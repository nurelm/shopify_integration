class Shipment

  def add_shopify_obj shopify_shipment, shopify_api
    @shopify_id = shopify_shipment['id']
    @shopify_order_id = shopify_shipment['order_id']
    order = shopify_api.order(@shopify_order_id).first
    @email = order.email
    @status = shopify_shipment['status']
    @shipping_method = shopify_shipment['tracking_company'] + ' ' + shopify_shipment['service']
    @tracking = shopify_shipment['tracking_number']
    @shipped_at = shopify_shipment['created_at']
    @line_items = Array.new
    shopify_shipment['line_items'].each do |shopify_li|
      line_item = LineItem.new
      @line_items << line_item.add_shopify_obj(shopify_li, shopify_api)
    end
    @shipping_address = order.shipping_address
    
    self
  end
  
  def wombat_obj
    [
      {
        'id' => @shopify_id,
        'order_id' => @shopify_order_id,
        'email' => @email,
        'status' => @status,
        'shipping_method' => @shipping_method,
        'tracking' => @tracking,
        'shipped_at' => @shipped_at,
        'shipping_address' => @shipping_address,
        'items' => Util.wombat_array(@line_items)
      }
    ]
  end

end
