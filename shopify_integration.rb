require "sinatra"
require "endpoint_base"

require_all 'lib'

class ShopifyIntegration < EndpointBase::Sinatra::Base
  post '/get_orders' do
    shopify_action 'get_orders', 'order'
  end

  post '/get_products' do
    shopify_action 'get_products', 'product'
  end

  post '/get_shipments' do
    shopify_action 'get_shipments', 'shipment'
  end

  post '/get_customers' do
    shopify_action 'get_customers', 'customer'
  end

  post '/get_inventories' do
    shopify_action 'get_inventories', 'inventory'
  end

  post '/add_product' do
    shopify_action 'add_product', 'product'
  end

  post '/add_customer' do
    shopify_action 'add_customer', 'customer'
  end

  post '/update_customer' do
    shopify_action 'update_customer', 'customer'
  end

  post '/add_product' do
    shopify_action 'add_product', 'product'
  end

  post '/update_product' do
    shopify_action 'update_product', 'product'
  end

  post '/set_invetory' do
    shopify_action 'set_inventory', ''
  end

  private

  def shopify_action action, obj_name
    begin
      shopify = ShopifyAPI.new(@payload, @config)
      response  = shopify.send(action)
      action_type = action.split('_')[0]

      case action_type
      when 'get'
        response['objects'].each do |obj|
          add_object obj_name, obj
        end
        add_parameter 'since', Time.now.utc.iso8601

      when 'add'
        # This will do a partial update in Wombat, only the new key
        # shopify_id will be added everything else will be the same
        add_object obj_name, { id: @payload[obj_name]['id'],
                               shopify_id: response['objects'][obj_name]['id'] }
      end

      result 200, response['message']
    rescue => e
      print e.cause
      print e.backtrace.join("\n")
      result 500, e.message
    end
  end

end
