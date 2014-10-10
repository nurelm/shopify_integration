module Shopify
  class Shipment
    include APIHelper

    def initialize(payload, config)
      @shipment = payload
      @config = config
    end

    def ship!
      if @shipment['status'] == "shipped" && shopify_order_id
        begin
          api_post(
            "orders/#{shopify_order_id}/fulfillments.json",
            {
              fulfillment: { tracking_number: @shipment['tracking'] }
            }
          )
        rescue RestClient::UnprocessableEntity
          raise "Shipment #{@shipment['id']} has already been marked as shipped on Shopify!"
        end

        "Updated shipment #{@shipment['id']} with tracking number #{@shipment['tracking']}."
      else
        raise "Order #{@shipment['order_id']} not found on Shopify" unless shopify_order_id
      end
    end

    def shopify_order_id
      @shopify_order_id ||= @shipment['shopify_order_id'] || find_order_id_by_order_number(@shipment['order_id'])
    end

    def find_order_id_by_order_number(order_number)
      order_number = order_number.split("-").last
      count = (api_get 'orders/count')['count']
      page_size = 250
      pages = (count / page_size.to_f).ceil
      current_page = 1

      while current_page <= pages do
        response = api_get 'orders',
                           {'limit' => page_size, 'page' => current_page}
        current_page += 1
        response['orders'].each do |order|
          return order['id'].to_s if order['order_number'].to_s == order_number
        end
      end

      return nil
    end
  end
end
