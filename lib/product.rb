class Product
  
  attr_reader :shopify_id

  def add_shopify_obj shopify_product, shopify_api
    @shopify_id = shopify_product['id']
    @name = shopify_product['title']
    @description = shopify_product['body_html']
    
    @variants = Array.new
    shopify_product['variants'].each do |shopify_variant|
      variant = Variant.new
      variant.add_shopify_obj shopify_variant, shopify_product['options']
      @variants << variant
    end
    
    @images = Array.new
    shopify_product['images'].each do |shopify_image|
      image = Image.new
      image.add_shopify_obj shopify_image
      @images << image
    end
    
    self
  end
  
  def add_wombat_obj wombat_product, shopify_api
    @wombat_id = wombat_product['id'].to_s
    @name = wombat_product['name']
    @description = wombat_product['description']
    
    @variants = Array.new
    wombat_product['variants'].each do |wombat_variant|
      variant = Variant.new
      variant.add_wombat_obj wombat_variant
      @variants << variant
    end

    @images = Array.new
    wombat_product['images'].each do |wombat_image|
      image = Image.new
      image.add_wombat_obj wombat_image
      @images << image
    end
    
    self
  end
  
  def wombat_obj
    {
      'id' => @shopify_id,
      'shopify_id' => @shopify_id,
      'name' => @name,
      'sku' => @name,
      'description' => @description,
      'meta_description' => @description,
      'variants' => Util.wombat_array(@variants),
      'images' => Util.wombat_array(@images)
    }
  end
  
  def shopify_obj
    {
      'product'=> {
        'title'=> @name,
        'body_html'=> @description,
        'product_type' => 'None',
        'metafields' => Util.shopify_metafields('wombat_id', @wombat_id, 'string', 'product'),
        'variants'=> Util.shopify_array(@variants),
        'images' => Util.shopify_array(@images)
      }
    }
  end

end