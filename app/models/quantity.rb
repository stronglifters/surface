class Quantity
  attr_reader :amount, :unit

  def initialize(amount, unit)
    @amount = amount
    @unit = unit
  end

  def to(target_unit)
    # TODO:: convert amount to target unit
    @amount
  end

  def to_f
    @amount.to_f
  end

  def eql?(other)
    converted = other.to(unit)
    self.amount == converted
  end

  def to_s
    to_f.to_s
  end
end
