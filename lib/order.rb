class Order

  def add_shopify_obj shopify_order
    @shopify_id = shopify_order['id']
  end
  
  def wombat_obj
    [
      {
        'id' => 'R154085346953692',
        'status' => 'complete',
        'channel' => 'spree',
        'email' => 'spree@example.com',
        'currency' => 'USD',
        'placed_on' => '2014-02-03T17:29:15.219Z',
        'totals' => {
          'item' => 200,
          'adjustment' => 20,
          'tax' => 10,
          'shipping' => 10,
          'payment' => 220,
          'order' => 220
        },
        'line_items' => [
          {
            'product_id' => 'SPREE-T-SHIRT',
            'name' => 'Spree T-Shirt',
            'quantity' => 2,
            'price' => 100
          }
        ],
        'adjustments' => [
          {
            'name' => 'Tax',
            'value' => 10
          },
          {
            'name' => 'Shipping',
            'value' => 5
          },
          {
            'name' => 'Shipping',
            'value' => 5
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