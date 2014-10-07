module Shopify
  class Shipment
    include APIHelper

    def initialize(payload, config)
      @shipment = payload
      @config = config
    end

    def update!
      if @shipment['status'] == "shipped" && @shipment['shopify_order_id']
        begin
          api_post(
            "orders/#{@shipment['shopify_order_id']}/fulfillments.json",
            {
              fulfillment: { tracking_number: @shipment['tracking'] }
            }
          )
        rescue RestClient::UnprocessableEntity
          raise "Shipment #{@shipment['id']} has already been marked as shipped on Shopify!"
        end

        "Updated shipment #{@shipment['id']} with tracking number #{@shipment['tracking']}."
      end
    end
  end
end
