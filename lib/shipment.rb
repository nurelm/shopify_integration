class Shipment

  def add_shopify_obj shopify_shipment, shopify_api
    @shopify_id = shopify_shipment['id']
  end
  
  def wombat_obj
    [
      {
        'id' => @shopify_id,
      }
    ]
  end

end
