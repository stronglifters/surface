class Csv::Exercise
  attr_accessor :name, :weight_kg, :weight_lb
  attr_accessor :sets

  def initialize(attributes = {})
    attributes.each do |attribute|
      send("#{attribute.first}=", attribute.last)
    end
  end
end
