require "sinatra"
require "endpoint_base"

require_all 'lib'

class ShopifyIntegration < EndpointBase::Sinatra::Base
  post '/get_orders' do
    shopify_action('get_orders')
  end

  post '/get_products' do
    shopify_action('get_products')
  end

  post '/get_shipments' do
    shopify_action('get_shipments')
  end

  post '/get_customers' do
    shopify_action('get_customers')
  end
  

  private

  def shopify_action(action)
    begin
      shopify = ShopifyAPI.new(@payload, @config)
      response  = shopify.send(action)
      result 200, response
    rescue => e
      print e.cause
      print e.backtrace.join("\n")
      result 500, e.message
    end
  end

end
