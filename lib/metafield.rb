class Metafield

  def initialize wombat_id
    @wombat_id = wombat_id
  end

  def shopify_obj
    {
      'metafield' => {
        'namespace' => 'wombat',
        'key' => 'wombat_id',
        'value' => @wombat_id,
        'value_type' => 'string'
      }
    }
  end
end
