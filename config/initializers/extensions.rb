class Fixnum
  def lbs
    to_f.lbs
  end

  def kg
    to_f.kg
  end
end

class Float
  def lbs
    Quantity.new(self, :lbs)
  end

  def kg
    Quantity.new(self, :kg)
  end
end

class NilClass
  def to(units)
    0.0.lbs.to(units)
  end
end
