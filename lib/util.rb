class Util

  def self.wombat_array objs
    wombat_array = Array.new
    objs.each do |obj|
      wombat_array << obj.wombat_obj
    end
    wombat_array
  end

  def self.shopify_array objs
    shopify_array = Array.new
    objs.each do |obj|
      shopify_array << obj.shopify_obj
    end
    shopify_array
  end
  

end