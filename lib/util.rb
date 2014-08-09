class Util

  def self.wombat_obj_array obj_array
    wombat_obj_array = Array.new
    obj_array.each do |obj|
      wombat_obj_array << obj.wombat_obj
    end
    wombat_obj_array
  end

end