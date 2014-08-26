class Product

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
    wombat_obj = Array.new

    @variants.each do |variant|
      wombat_obj << {
        "id" => variant.shopify_id,
        "parent_id" => @shopify_id,
        "name" => "#{@name} (#{variant.name})",
        "sku" => variant.sku,
        "description" => @description,
        "price" => variant.price,
        "meta_description" => @description,
        "shipping_category" => variant.shipping_category,
        "options" => variant.options,
        "images" => Util.wombat_array(@images)
      }
    end
    
    wombat_obj
  end
  
  def shopify_obj
    {
      "product"=> {
        "title"=> @name,
        "body_html"=> @description,
        "product_type" => "None",
        "variants"=> Util.shopify_array(@variants),
        "images" => Util.shopify_array(@images)
      }
    }
  end

end