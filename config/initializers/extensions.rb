class Fixnum
  def lbs
    to_f.lbs
  end
end

class Float
  def lbs
    Quantity.new(self, :lbs)
  end
end

class NilClass
  def to(units)
    0.0.lbs.to(units)
  end
end
