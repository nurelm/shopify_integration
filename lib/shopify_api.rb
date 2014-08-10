require 'json'
require 'rest-client'
require 'pp'

class ShopifyAPI
  CLIENT_SECRET = "893e71f8102c0da571e4aab02e408b7e"
  BASE_API_URI = ""

  attr_accessor :order, :config, :payload, :request

  def initialize(payload, config={})
    @payload = payload
    @config = config
  end

  def wombat_products
    wombat_hash 'products', Product
  end

  def wombat_customers
    wombat_hash 'customers', Customer
  end

  def wombat_shipments
    wombat_hash 'shipments', Shipment
  end

  def wombat_orders
    wombat_hash 'orders', Order
  end
  
  def transactions order_id
    get_objs "orders/#{order_id}/transactions", Transaction
  end


  private

  def wombat_hash objs_name, obj_class
    wombat_hash = Hash.new
    wombat_hash[objs_name] = wombat_array(get_objs objs_name, obj_class)
    wombat_hash
  end

  def get_objs objs_name, obj_class
    objs = Array.new
    begin
      shopify_objs = api_get objs_name
      shopify_objs[objs_name.split('/')[-1]].each do |shopify_obj|
        obj = obj_class.new
        obj.add_shopify_obj shopify_obj, self
        objs << obj
      end

      objs
    rescue => e
      message = "Unable to retrieve #{objs_name}: \n" + e.message
      raise ShopifyError, message, caller
    end
  end
  
  def wombat_array objs
    wombat_array = Array.new
    objs.each do |obj|
      wombat_array += obj.wombat_obj
    end

    wombat_array
  end
  
  def api_get resource
    response = RestClient.get shopify_url + (final_resource resource)
    JSON.parse response
  end

  def api_post resource, data
    response = RestClient.post shopify_url + resource, data,
                               :content_type => :json, :accept => :json
    JSON.parse response
  end
  
  def shopify_url
    "https://#{@config['shopify_apikey']}:#{@config['shopify_password']}@#{@config['shopify_host']}/admin/"
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
