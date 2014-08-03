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
    product = Product.new
    begin
      api_get 'products.json'
    rescue => e
      message = "Unable to retrieve products: \n" + e.message
      raise ShopifyError, message, caller
    end
  end
  
  private
  
  def api_get resource
    response = RestClient.get shopify_url + resource
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

end

class AuthenticationError < StandardError; end
class ShopifyError < StandardError; end
