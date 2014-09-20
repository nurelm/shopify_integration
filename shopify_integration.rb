require "sinatra"
require "endpoint_base"

require_all 'lib'

class ShopifyIntegration < EndpointBase::Sinatra::Base

  ## Supported endpoints:
  ## get_ for orders, products, inventories, shipments, customers
  ## add_ for product, customer
  ## update_ for product, customer, shipment
  ## set_inventory
  post '/*_*' do |action, obj_name|
    shopify_action "#{action}_#{obj_name}", obj_name.singularize
  end

  private

    def shopify_action action, obj_name
      begin
        action_type = action.split('_')[0]

        if (action_type == 'add' && !@payload[obj_name]['shopify_id'].nil?) ||
           (action_type == 'update' && @payload[obj_name]['shopify_id'].nil?)
           return result 200
        end

        shopify = ShopifyAPI.new(@payload, @config)
        response  = shopify.send(action)

        case action_type
        when 'get'
          response['objects'].each do |obj|
            add_object obj_name, obj
          end
          add_parameter 'since', Time.now.utc.iso8601

        when 'add'
          ## This will do a partial update in Wombat, only the new key
          ## shopify_id will be added everything else will be the same
          add_object obj_name,
                     { 'id' => @payload[obj_name]['id'],
                       'shopify_id' => response['objects'][obj_name]['id'].to_s }
        end

        if response.has_key?('additional_objs') &&
           response.has_key?('additional_objs_name')
          response['additional_objs'].each do |obj|
            add_object response['additional_objs_name'], obj
          end
        end

        if response['message'].nil?
          return result 200
        else
          return result 200, response['message']
        end
      rescue => e
        print e.cause
        print e.backtrace.join("\n")
        result 500, e.response.nil? ? e.message : e.response
      end
    end

end
