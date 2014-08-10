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

  def get_products
    get_objs 'products', Product
  end

  def get_customers
    get_objs 'customers', Customer
  end

  def get_shipments
    get_objs 'shipments', Shipment
  end

  def get_orders
    get_objs 'orders', Order
  end


  private

  def get_objs objs_name, obj_class
    wombat_response = Hash.new
    wombat_response[objs_name] = Array.new
    begin
      shopify_objs = api_get objs_name
      shopify_objs[objs_name].each do |shopify_obj|
        obj = obj_class.new
        obj.add_shopify_obj shopify_obj
        wombat_response[objs_name] += obj.wombat_obj
      end

      wombat_response
    rescue => e
      message = "Unable to retrieve #{objs_name}: \n" + e.message
      raise ShopifyError, message, caller
    end
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
