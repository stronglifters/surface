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

  def +(other)
    Quantity.new(amount + amount_from(other), unit)
  end

  def >(other)
    self.amount > amount_from(other)
  end

  def >=(other)
    self.>(other) || eql?(other)
  end

  def <(other)
    self.amount < amount_from(other)
  end

  def eql?(other, delta = 0.1)
    (self.amount - amount_from(other)).abs <= delta
  end

  def ==(other)
    eql?(other)
  end

  def to_s
    to_f.to_s
  end

  private

  def amount_from(quantity)
    quantity.respond_to?(:to) ? quantity.to(unit).amount : quantity
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
