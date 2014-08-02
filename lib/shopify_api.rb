require 'json'

class ShopifyAPI
  CLIENT_ID = "sugar"
  CLIENT_SECRET = ""
  BASE_API_URI = "/rest/v10"

  attr_accessor :order, :config, :payload, :request

  def initialize(payload, config={})
    @payload = payload
    @config = config
    authenticate!
  end

  def authenticate!
    raise AuthenticationError if
        @config['shopify_username'].nil? || @config['shopify_password'].nil?

    @client = Oauth2Client.new CLIENT_ID,
                               CLIENT_SECRET,
                               BASE_API_URI,
                               @config['shopify_url'],
                               @config['shopify_username'],
                               @config['shopify_password']
  end

  def server_mode
    # Augury.test? ? 'Test' : 'Production'
    (ENV['shopify_INTEGRATION_SERVER_MODE'] || 'Test').capitalize
  end

  def get_products
    product = Product.new
    begin
    rescue => e
      message = "Unable to retrieve products: \n" + e.message
      raise ShopifyError, message, caller
    end
  end

end

class AuthenticationError < StandardError; end
class ShopifyError < StandardError; end
