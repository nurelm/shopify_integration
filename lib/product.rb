class Product

  def add_shopify_obj shopify_product
    @shopify_id = shopify_product['id']
    @name = shopify_product['title']
    @description = shopify_product['body_html']
    
    @variants = Array.new
    shopify_product['variants'].each do |shopify_variant|
      variant = Variant.new
      variant.add_shopify_obj shopify_variant
      @variants << variant
    end
    
    @images = Array.new
    shopify_product['images'].each do |shopify_image|
      
    end
    
    @taxons = Array.new
  end
  
  def wombat_obj
    ## Taxons
    
    ## Options
    
    ## Images

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
        "shipping_category" => variant.shipping_category
      }
    end
    
    wombat_obj
  end

end