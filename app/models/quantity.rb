class Quantity
  attr_reader :amount, :unit

  def initialize(amount, unit)
    @amount = amount
    @unit = Unit.for(unit)
  end

  def to(target_unit)
    Quantity.new(Unit.for(target_unit).convert(amount, unit), target_unit)
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


class Unit
  def self.for(unit)
    case unit
    when :lbs, :lb
      Pound.new
    when :kg, :kgs
      Kilogram.new
    end
  end
end

class Pound < Unit
  def convert(amount, unit)
    if unit.is_a? Kilogram
      amount * 2.20462
    end
  end
end

class Kilogram < Unit
  def convert(amount, unit)
    if unit.is_a? Pound
      amount * 0.453592
    elsif unit.is_a? Kilogram
      amount
    end
  end
end
