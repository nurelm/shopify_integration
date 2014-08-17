require "sinatra"
require "endpoint_base"

require_all 'lib'

class ShopifyIntegration < EndpointBase::Sinatra::Base
  post '/get_orders' do
    add_object shopify_action('wombat_orders')
  end

  post '/get_products' do
    add_object shopify_action('wombat_products')
  end

  post '/get_shipments' do
    add_object shopify_action('wombat_shipments')
  end

  post '/get_customers' do
    add_object shopify_action('wombat_customers')
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
