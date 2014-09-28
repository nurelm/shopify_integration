class Image
  attr_reader :url, :position

  def add_shopify_obj shopify_image
    @url = shopify_image['src']
    @position = shopify_image['position']
  end

  def add_wombat_obj wombat_image
    @url = wombat_image['url']
    @position = wombat_image['position']
  end

  def wombat_obj
    {
      'url' => @url,
      'position' => @position
    }
  end

  def shopify_obj
    {
      'src' => @url,
      'position' => @position
    }
  end
end
