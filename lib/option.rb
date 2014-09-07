class Option

  def add_wombat_obj wombat_option
    @name = wombat_option
  end
  
  def add_shopify_obj shopify_option
    @name = shopify_option['name']
  end
  
  def wombat_obj
    @name
  end

  def shopify_obj
    {
      'name' => @name,
    }
  end
end
