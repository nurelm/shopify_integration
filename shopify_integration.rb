require "sinatra"
require "endpoint_base"

require_all 'lib'

class ShopifyIntegration < EndpointBase::Sinatra::Base
  post '/get_orders' do
    shopify_action('get_wombat_orders')
  end

  post '/get_products' do
    shopify_action('get_wombat_products')
  end

  post '/get_shipments' do
    shopify_action('get_wombat_shipments')
  end

  post '/get_customers' do
    shopify_action('get_wombat_customers')
  end
  
  post '/add_product' do
    shopify_action('add_wombat_product')
  end
  
  post '/add_customer' do
    shopify_action('add_wombat_customer')
  end

  private

  def shopify_action(action)
    begin
      shopify = ShopifyAPI.new(@payload, @config)
      response  = shopify.send(action)
      response['objects'].each do |obj|
        add_object "product", obj
      end
      result 200, response['message']
    rescue => e
      print e.cause
      print e.backtrace.join("\n")
      result 500, e.message
    end
  end

end
