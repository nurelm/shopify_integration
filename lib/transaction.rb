class Transaction
  
  attr_reader :amount, :authorization, :created_at, :gateway,
              :shopify_id, :kind, :location_id, :message, :status,
              :test, :shopify_user_id, :shopify_order_id, :device_id
  
  def add_shopify_obj shopify_object, shopify_api
    @amount = shopify_object['amount']
    @authorization = shopify_object['authorization']
    @created_at = shopify_object['created_at']
    @gateway = shopify_object['gateway']
    @shopify_id = shopify_object['id']
    @kind = shopify_object['kind']
    @location_id = shopify_object['location_id']
    @message = shopify_object['message']
    @status = shopify_object['status']
    @test = shopify_object['test']
    @shopify_user_id = shopify_object['user_id']
    @shopify_order_id = shopify_object['order_id']
    @device_id = shopify_object['device_id']
    
    self
  end

end