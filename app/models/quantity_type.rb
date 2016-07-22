class QuantityType < ActiveRecord::Type::Float
  def cast(value)
    return nil if value.nil?

    if value.is_a? Quantity
      value.to(:lbs)
    else
      Quantity.new(value.to_f, :lbs)
    end
  end

  def serialize(value)
    if value.is_a? Quantity
      super(value.to(:lbs).to_f)
    else
      super(value)
    end
  end
end
