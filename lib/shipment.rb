class Shipment

  attr_reader :id, :shopify_id, :shopify_order_id, :status

  def add_shopify_obj shopify_shipment, shopify_api
    @shopify_id = shopify_shipment['id']
    @shopify_order_id = shopify_shipment['order_id']
    @source = Util.shopify_host shopify_api.config
    order = shopify_api.order(@shopify_order_id).first
    @email = order.email
    @status = Util.wombat_shipment_status shopify_shipment['status']
    @shipping_method = (shopify_shipment['tracking_company'] || 'tracking company not set') + ' / ' +
                       (shopify_shipment['service'] || 'service not set')
    @tracking = shopify_shipment['tracking_number']
    @shipped_at = shopify_shipment['created_at']
    @line_items = Array.new
    shopify_shipment['line_items'].each do |shopify_li|
      line_item = LineItem.new
      line_item.add_shopify_obj(shopify_li, shopify_api)
      @line_items << line_item.add_shopify_obj(shopify_li, shopify_api)
    end
    @shipping_address = order.shipping_address
    @billing_address = order.billing_address

    self
  end

  def add_wombat_obj wombat_shipment, shopify_api
    @shopify_order_id = wombat_shipment['id']
    @status = Util.shopify_shipment_status wombat_shipment['status']
    @shipping_method = wombat_shipment['shipping_method']
    @tracking_number = wombat_shipment['tracking']

    self
  end

  def shopify_obj
    {
      'status' => @status,
      'tracking_company' => @shipping_method,
      'tracking_number' => @tracking_number,
    }
  end

  def wombat_obj
    {
      'id' => @shopify_order_id.to_s,
      'shopify_id' => @shopify_id.to_s,
      'source' => @source,
      'order_id' => @shopify_order_id.to_s,
      'email' => @email,
      'status' => @status,
      'shipping_method' => @shipping_method,
      'tracking' => @tracking,
      'shipped_at' => @shipped_at,
      'shipping_address' => @shipping_address,
      'billing_address' => @billing_address,
      'items' => Util.wombat_array(@line_items)
    }
  end

  def self.wombat_obj_from_order order
    {
      'id' => order['id'],
      'shopify_order_id' => order['shopify_id'],
      'order_id' => order['id'],
      'email' => order['email'],
      'channel' => order['source'],
      'shipping_address' => order['shipping_address'],
      'billing_address' => order['billing_address'],
      'items' => order['line_items'],
      'totals' => order['totals']
    }
  end

end
