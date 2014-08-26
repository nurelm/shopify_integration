class Address

  def add_shopify_obj shopify_address
    return self if shopify_address.nil?
    
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
    return self if wombat_address.nil?

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
      'address1' => @address1.nil? ? "" : @address1,
      'address2' => @address2.nil? ? "" : @address2,
      'zipcode' => @zipcode.nil? ? "" : @zipcode,
      'city' => @city.nil? ? "" : @city,
      'state' => @state.nil? ? "" : @state,
      'country' => @country.nil? ? "" : @country,
      'phone' => @phone.nil? ? "" : @phone
    }
  end
  
  def shopify_obj
    {
      'address1' => @address1.nil? ? "" : @address1,
      'address2' => @address2.nil? ? "" : @address2,
      'zip' => @zipcode.nil? ? "" : @zipcode,
      'city' => @city.nil? ? "" : @city,
      'province' => @state.nil? ? "" : @state,
      'country' => @country.nil? ? "" : @country,
      'phone' => @phone.nil? ? "" : @phone
    }
  end

end
