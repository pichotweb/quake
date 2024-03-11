module GraphHelper

  def self.get_labels dataset
    dataset.map {|key, value| "'#{key}'"}.join(",").html_safe
  end

  def self.get_data dataset
    dataset.map {|key, value| "'#{value}'"}.join(",").html_safe
  end

  def self.random_colors quantity
    quantity.times.map do |i|
      r = rand(255)
      g = rand(255)
      b = rand(255)
      "'rgb(#{r},#{g},#{b})'"
    end.join(',').html_safe
  end
end
