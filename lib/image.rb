class Image
  attr_reader :url, :position

  def add_shopify_obj shopify_image
    @url = shopify_image['src']
    @position = shopify_image['position']
  end
  
  def wombat_obj
    {
      'url' => @url,
      'position' => @position
    }
  end
end
