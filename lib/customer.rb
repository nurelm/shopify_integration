class Customer

  def add_shopify_obj shopify_customer, shopify_api
    @shopify_id = shopify_customer['id']
    @firstname = shopify_customer['first_name']
    @lastname = shopify_customer['last_name']
    @email = shopify_customer['email']
    @default_address = {
      'address1' => shopify_customer['default_address']['address1'],
      'address2' => shopify_customer['default_address']['address2'],
      'zipcode' => shopify_customer['default_address']['zip'],
      'city' => shopify_customer['default_address']['city'],
      'state' => shopify_customer['default_address']['province'],
      'country' => shopify_customer['default_address']['country_code'],
      'phone' => shopify_customer['default_address']['phone']
    }
  end
  
  def wombat_obj
    [
      {
        'id' => @shopify_id,
        'firstname' => @firstname,
        'lastname' => @lastname,
        'email' => @email,
        'shipping_address' => @default_address,
        'billing_address' => @default_address
      }
    ]
  end

end
