class Option

  def add_wombat_obj wombat_option
    @name = wombat_option
  end
  
  def shopify_obj
    {
      'name' => @name,
    }
  end
end
