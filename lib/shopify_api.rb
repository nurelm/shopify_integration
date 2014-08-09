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
    wombat_response = Hash.new
    wombat_response['products'] = Array.new
    begin
      shopify_products = api_get 'products'
      shopify_products['products'].each do |shopify_product|
        product = Product.new
        product.add_shopify_obj shopify_product
        wombat_response['products'] += product.wombat_obj
      end

      wombat_response
    rescue => e
      message = "Unable to retrieve products: \n" + e.message
      raise ShopifyError, message, caller
    end
  end


  private
  
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
