require 'json'
require 'rest-client'
require 'pp'

class ShopifyAPI
  attr_accessor :order, :config, :payload, :request

  def initialize payload, config={}
    @payload = payload
    @config = config
  end

  def get_products
    get_webhook_results 'products', Product
  end

  def get_customers
    get_webhook_results 'customers', Customer
  end

  def get_inventories
    inventories = Array.new
    get_objs('products', Product).each do |product|
      product.variants.each do |variant|
        unless variant.sku.blank?
          inventory = Inventory.new
          inventory.add_obj variant
          inventories << inventory.wombat_obj
        end
      end
    end
    get_reply inventories, "Retrieved inventories."
  end

  def get_shipments
    shipments = Array.new
    get_objs('orders', Order).each do |order|
      shipments += shipments(order.shopify_id)
    end
    get_webhook_results 'shipments', shipments, false
  end

  def get_orders
    get_webhook_results 'orders', Order
    orders = Util.wombat_array(get_objs('orders', Order))

    shipments = Array.new
    orders.each do |order|
      shipments << Shipment.wombat_obj_from_order(order)
    end

    {
      'objects' => orders,
      'message' => "Successfully retrieved #{orders.length} orders " +
                   "from Shopify.",
      'additional_objs' => shipments,
      'additional_objs_name' => 'shipment'
    }
  end

  def add_product
    product = Product.new(Util.manage_inv @config)
    product.add_wombat_obj @payload['product'], self
    result = api_post 'products.json', product.shopify_obj

    ## Build a list of inventory objects to add to Wombat
    inventories = Array.new
    result['product']['variants'].each do |shopify_variant|
      unless shopify_variant['sku'].blank?
        variant = Variant.new(Util.manage_inv @config)
        variant.add_shopify_obj shopify_variant, result['product']['options']
        inventory = Inventory.new.add_obj variant
        inventories << inventory.wombat_obj
      end
    end

    {
      'objects' => result,
      'message' => "Product added with Shopify ID of " +
                   "#{result['product']['id']} was added.",
      'additional_objs' => inventories,
      'additional_objs_name' => 'inventory'
    }
  end

  def update_product
    product = Product.new(Util.manage_inv @config)
    product.add_wombat_obj @payload['product'], self

    ## Using shopify_obj_no_variants is a workaround until
    ## specifying variants' Shopify IDs is added
    result = api_put "products/#{product.shopify_id}.json",
                     product.shopify_obj_no_variants
    {
      'objects' => result,
      'message' => "Product added with Shopify ID of " +
                   "#{result['product']['id']} was updated."
    }
  end

  def update_shipment
    shipment = Shipment.new.add_wombat_obj @payload['shipment'], self
    unless shipment.status == 'ready' || shipment.shopify_id.nil?
      ## If Shopify ID exists, update shipment
      result = api_put "orders/#{shipment.shopify_order_id}/" +
                       "fulfillments/#{shipment.shopify_id}.json",
                       {'fulfillment' => shipment.shopify_obj}
      {
        'objects' => result,
        'message' => "Updated shipment for order with Shopify ID of " +
                     "#{shipment.shopify_order_id}."
      }
    end
  end

  def add_customer
    customer = Customer.new
    customer.add_wombat_obj @payload['customer'], self
    result = api_post 'customers.json', customer.shopify_obj
    {
      'objects' => result,
      'message' => "Customer with Shopify ID of " +
                   "#{result['customer']['id']} was added."
    }
  end

  def update_customer
    customer = Customer.new
    customer.add_wombat_obj @payload['customer'], self
    result = api_put "customers/#{customer.shopify_id}.json",
                     customer.shopify_obj
    {
      'objects' => result,
      'message' => "Customer with Shopify ID of " +
                   "#{result['customer']['id']} was updated."
    }
  end

  def set_inventory
    inventory = Inventory.new
    inventory.add_wombat_obj @payload['inventory']
    result = api_put "variants/#{inventory.shopify_id}.json",
                     {'variant' => inventory.shopify_obj}
    {
      'objects' => result,
      'message' => "Set inventory of SKU #{inventory.sku} " +
                   "to #{inventory.quantity}."
    }
  end

  def order order_id
    get_objs "orders/#{order_id}", Order
  end

  def transactions order_id
    get_objs "orders/#{order_id}/transactions", Transaction
  end

  def shipments order_id
    get_objs "orders/#{order_id}/fulfillments", Shipment
  end


  private

  def get_webhook_results obj_name, obj, get_objs = true
    objs = Util.wombat_array(get_objs ? get_objs(obj_name, obj) : obj)
    get_reply objs, "Successfully retrieved #{objs.length} #{obj_name} " +
                    "from Shopify."
  end

  def get_reply objs, message
    {
      'objects' => objs,
      'message' => message
    }
  end

  def get_objs objs_name, obj_class
    objs = Array.new
    begin
      shopify_objs = api_get objs_name
      if shopify_objs.values.first.kind_of?(Array)
        shopify_objs.values.first.each do |shopify_obj|
          obj = obj_class.new
          obj.add_shopify_obj shopify_obj, self
          objs << obj
        end
      else
        obj = obj_class.new
        obj.add_shopify_obj shopify_objs.values.first, self
        objs << obj
      end

      objs
    rescue => e
      message = "Unable to retrieve #{objs_name}: " + e.message
      raise ShopifyError, message
    end
  end

  def api_get resource
    response = RestClient.get shopify_url + (final_resource resource)
    JSON.parse response
  end

  def api_post resource, data
    response = RestClient.post shopify_url + resource, data.to_json,
                               :content_type => :json, :accept => :json
    JSON.parse response
  end

  def api_put resource, data
    response = RestClient.put shopify_url + resource, data.to_json,
                              :content_type => :json, :accept => :json
    JSON.parse response
  end

  def shopify_url
    "https://#{Util.shopify_apikey @config}:#{Util.shopify_password @config}" +
    "@#{Util.shopify_host @config}/admin/"
  end

  def final_resource resource
    if !@config['since'].nil?
      resource += ".json?updated_at_min=#{@config['since']}"
    elsif !@config['id'].nil?
      resource += "/#{@config['id']}.json"
    else
      resource += '.json'
    end
    resource
  end

end

class AuthenticationError < StandardError; end
class ShopifyError < StandardError; end
