class Order

  def add_shopify_obj shopify_order, shopify_api
    @shopify_id = shopify_order['id']
    @status = shopify_order['financial_status'] + ' / ' + shopify_order['fulfillment_status']
    @email = shopify_order['email']
    @currency = shopify_order['currency']
    @placed_on = shopify_order['created_at']
    @totals_item = shopify_order['total_line_items_price'].to_f
    @totals_tax = shopify_order['total_tax'].to_f
    @totals_discounts = shopify_order['total_discounts'].to_f
    @totals_shipping = 0.00
    shopify_order['shipping_lines'].each do |shipping_line|
      @totals_shipping += shipping_line['price'].to_f
    end
    @totals_payment = 0.00
    shopify_api.transactions(@shopify_id).each do |transaction|
      if transaction.kind == 'capture' and transaction.status == 'success'
        @totals_payment += transaction.amount.to_f
      end
    end
    @totals_order = shopify_order['total_price']
    @line_items = Array.new
    shopify_order['line_items'].each do |shopify_li|
      line_item = LineItem.new
      @line_items << line_item.add_shopify_obj(shopify_li, shopify_api)
    end
    
    self
  end
  
  def wombat_obj
    [
      {
        'id' => @shopify_id,
        'status' => @status,
        'channel' => 'shopify',
        'email' => @email,
        'currency' => @currency,
        'placed_on' => @placed_on,
        'totals' => {
          'item' => @totals_item,
          'tax' => @totals_tax,
          'shipping' => @totals_shipping,
          'payment' => @totals_payment,
          'order' => @totals_order
        },
        'line_items' => Util.wombat_array(@line_items),
        'adjustments' => [
          {
            'name' => 'Tax',
            'value' => @totals_tax
          },
          {
            'name' => 'Shipping',
            'value' => @totals_shipping
          },
          {
            'name' => 'Discounts',
            'value' => @totals_discounts
          }
        ],
        'shipping_address' => {
          'firstname' => 'Joe',
          'lastname' => 'Smith',
          'address1' => '1234 Awesome Street',
          'address2' => '',
          'zipcode' => '90210',
          'city' => 'Hollywood',
          'state' => 'California',
          'country' => 'US',
          'phone' => '0000000000'
        },
        'billing_address' => {
          'firstname' => 'Joe',
          'lastname' => 'Smith',
          'address1' => '1234 Awesome Street',
          'address2' => '',
          'zipcode' => '90210',
          'city' => 'Hollywood',
          'state' => 'California',
          'country' => 'US',
          'phone' => '0000000000'
        },
        'payments' => [
          {
            'number' => 63,
            'status' => 'completed',
            'amount' => 220,
            'payment_method' => 'Credit Card'
          }
        ]
      }      
    ]
  end
      
end