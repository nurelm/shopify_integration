class Address

  def add_shopify_obj shopify_address
    @address1 = shopify_address['address1']
    @address2 = shopify_address['address2']
    @zipcode = shopify_address['zip']
    @city = shopify_address['city']
    @state = shopify_address['province']
    @country = shopify_address['country_code']
    @phone = shopify_address['phone']
    
    self
  end
  
  def add_wombat_obj wombat_address
    @address1 = wombat_address['address1']
    @address2 = wombat_address['address2']
    @zipcode = wombat_address['zipcode']
    @city = wombat_address['city']
    @state = wombat_address['state']
    @country = wombat_address['country']
    @phone = wombat_address['phone']
    
    self
  end
  
  def wombat_obj
    {
      'address1' => @address1,
      'address2' => @address2,
      'zipcode' => @zipcode,
      'city' => @city,
      'state' => @state,
      'country' => @country,
      'phone' => @phone
    }
  end
  
  def shopify_obj
    {
      'address1' => @address1,
      'address2' => @address2,
      'zip' => @zipcode,
      'city' => @city,
      'province' => @state,
      'country' => @country,
      'phone' => @phone
    }
  end

end
