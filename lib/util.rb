class Util

  def self.wombat_array objs
    wombat_array = Array.new
    objs.each do |obj|
      wombat_array += obj.wombat_obj
    end

    wombat_array
  end
  

end