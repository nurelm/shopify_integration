class Inventory

  attr_reader :shopify_id, :sku, :quantity

  def add_obj variant
    @sku = variant.sku
    @shopify_id = variant.shopify_id
    @shopify_product_id = variant.shopify_product_id
    @quantity = variant.quantity

    self
  end

  def add_wombat_obj wombat_inventory
    @sku = wombat_inventory['product_id']
    @quantity = wombat_inventory['quanity']
    unless wombat_inventory['shopify_id'].nil?
      @shopify_id = wombat_inventory['shopify_id']
    end

    self
  end

  def wombat_obj
    {
      "id" => @sku.to_s,
      "product_id" => @sku.to_s,
      "shopify_id" => @shopify_id.to_s,
      'shopify_product_id' => @shopify_product_id.to_s,
      "quantity" => @quantity
    }
  end

  def shopify_obj
    {
      "inventory_quantity" => @quantity
    }
  end
end
