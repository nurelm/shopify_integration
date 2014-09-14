require "sinatra"
require "endpoint_base"

require_all 'lib'

class ShopifyIntegration < EndpointBase::Sinatra::Base

  ## Supported endpoints:
  ## get_ for orders, products, inventories, shipments, customers
  ## add_ for product, customer
  ## update_ for product, customer
  ## set_invetory
  post '/*_*' do |action, obj_name|
    shopify_action "#{action}_#{obj_name}", obj_name.singularize
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
          add_object obj_name,
                     { id: @payload[obj_name]['id'],
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
