class Payment

  def add_shopify_obj shopify_transaction, shopify_api
    @amount = shopify_transaction.amount
    @payment_method = shopify_transaction.gateway

    self
  end

  def wombat_obj
    {
      'status' => 'completed',
      'amount' => @amount.to_f,
      'payment_method' => @payment_method
    }
  end

end