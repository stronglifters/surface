class Quantity
  attr_reader :amount, :unit

  def initialize(amount, unit)
    @amount = amount
    @unit = UnitOfMeasure.for(unit)
  end

  def to(target_unit)
    Quantity.new(UnitOfMeasure.for(target_unit).convert(amount, unit), target_unit)
  end

  def to_f
    @amount.to_f
  end

  def eql?(other, delta = 0.1)
    converted = other.respond_to?(:to) ? other.to(unit).amount : other
    (self.amount - converted).abs <= delta
  end

  def to_s
    to_f.to_s
  end

  class UnitOfMeasure
    def self.for(unit)
      case unit
      when :lbs, :lb
        Pound.new
      when :kg, :kgs
        Kilogram.new
      else
        unit
      end
    end
  end

  class Pound < UnitOfMeasure
    def convert(amount, unit)
      case unit
      when Kilogram
        amount * 2.20462
      else
        amount
      end
    end
  end

  class Kilogram < UnitOfMeasure
    def convert(amount, unit)
      case unit
      when Pound
        amount * 0.453592
      else
        amount
      end
    end
  end
end
