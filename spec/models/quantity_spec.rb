require "spec_helper"

describe Quantity do
  describe "#to" do
    it "converts lbs to kgs" do
      lbs = Quantity.new(135.0, :lbs)
      expect(lbs.to(:kg).to_f.round(1)).to eql(61.2)
    end

    it "converts kgs to kgs" do
      kgs = Quantity.new(135.0, :kgs)
      expect(kgs.to(:kgs).to_f).to eql(135.0)
    end

    it "converts kgs to lbs" do
      kgs = Quantity.new(61.2, :kgs)
      expect(kgs.to(:lbs).to_f.round(0)).to eql(135)
    end

    it "converts lbs to lbs" do
      lbs = Quantity.new(135.0, :lbs)
      expect(lbs.to(:lbs).to_f).to eql(135.0)
    end
  end

  describe "#eql?" do
    it "is equal when both are lbs" do
      quantity = Quantity.new(135.0, :lbs)
      other = Quantity.new(135.0, :lbs)
      expect(quantity).to eql(other)
    end

    it "is equal when both are kgs" do
      quantity = Quantity.new(61.2, :kgs)
      other = Quantity.new(61.2, :kgs)
      expect(quantity).to eql(other)
    end

    it "is equal when different units" do
      quantity = Quantity.new(135.0, :lbs)
      other = Quantity.new(61.2, :kgs)
      expect(quantity).to eql(other)
    end

    it "is equal to a float" do
      quantity = Quantity.new(135.0, :lbs)
      expect(quantity).to eql(135.0)
    end

    it "is not equal" do
      quantity = Quantity.new(135.0, :lbs)
      other = Quantity.new(135.2, :lbs)
      expect(quantity).to_not eql(other)
    end
  end

  describe "#+" do
    it "adds lbs to lbs" do
      quantity = Quantity.new(135.0, :lbs)
      other = Quantity.new(135.0, :lbs)
      expect(quantity + other).to eql(Quantity.new(270.0, :lbs))
    end

    it "adds kgs to lbs" do
      quantity = Quantity.new(135.0, :lbs)
      other = Quantity.new(61.2, :kg)
      expect(quantity + other).to eql(Quantity.new(270.0, :lbs))
    end

    it "adds lbs to kgs" do
      quantity = Quantity.new(61.2, :kg)
      other = Quantity.new(135.0, :lbs)
      expect(quantity + other).to eql(Quantity.new(122.4, :kg))
    end

    it "adds a float to lbs" do
      quantity = Quantity.new(135.0, :lbs)
      other = 135.0
      expect(quantity + other).to eql(Quantity.new(270.0, :lbs))
    end
  end

  describe "#-" do
    it "subtracts lbs from lbs" do
      quantity = Quantity.new(135.0, :lbs)
      other = Quantity.new(135.0, :lbs)
      expect(quantity - other).to eql(Quantity.new(0.0, :lbs))
    end

    it "subtracts kgs from lbs" do
      quantity = Quantity.new(135.0, :lbs)
      other = Quantity.new(61.2, :kg)
      expect(quantity - other).to eql(Quantity.new(0.0, :lbs))
    end

    it "subtracts lbs from kgs" do
      quantity = Quantity.new(61.2, :kg)
      other = Quantity.new(135.0, :lbs)
      expect(quantity - other).to eql(Quantity.new(0.0, :kg))
    end

    it "subtracts a float from lbs" do
      quantity = Quantity.new(135.0, :lbs)
      other = 135.0
      expect(quantity - other).to eql(Quantity.new(0.0, :lbs))
    end
  end

  describe "#/" do
    it "divides lbs from lbs" do
      quantity = Quantity.new(135.0, :lbs)
      other = Quantity.new(135.0, :lbs)
      expect(quantity / other).to eql(Quantity.new(1.0, :lbs))
    end

    it "divides kgs from lbs" do
      quantity = Quantity.new(135.0, :lbs)
      other = Quantity.new(61.2, :kg)
      expect(quantity / other).to eql(Quantity.new(1.0, :lbs))
    end

    it "divides lbs from kgs" do
      quantity = Quantity.new(61.2, :kg)
      other = Quantity.new(135.0, :lbs)
      expect(quantity / other).to eql(Quantity.new(1.0, :kg))
    end

    it "divides a float from lbs" do
      quantity = Quantity.new(135.0, :lbs)
      other = 135.0
      expect(quantity / other).to eql(Quantity.new(1.0, :lbs))
    end
  end

  describe "#*" do
    it "multiples lbs with lbs" do
      quantity = Quantity.new(135.0, :lbs)
      other = Quantity.new(135.0, :lbs)
      expect(quantity * other).to eql(Quantity.new(18_225.0, :lbs))
    end

    it "multiples a float with lbs" do
      quantity = Quantity.new(135.0, :lbs)
      other = 135.0
      expect(quantity * other).to eql(Quantity.new(18_225.0, :lbs))
    end
  end

  describe "#>" do
    it "compares lbs with lbs" do
      quantity = Quantity.new(135.1, :lbs)
      other = Quantity.new(135.0, :lbs)
      expect(quantity).to be > other
      expect(other).to_not be > quantity
    end
  end

  describe "#>=" do
    it "compares lbs with lbs" do
      quantity = Quantity.new(135.2, :lbs)
      other = Quantity.new(135.0, :lbs)
      expect(quantity).to be >= quantity
      expect(quantity).to be >= other
      expect(other).to_not be >= quantity
    end
  end

  describe "#<" do
    it "compares lbs with lbs" do
      quantity = Quantity.new(135.1, :lbs)
      other = Quantity.new(135.0, :lbs)
      expect(quantity).to_not be < other
      expect(other).to be < quantity
    end
  end

  describe "#to_json" do
    it 'format the amount and unit to json' do
      expect(100.lbs.to_json).to eql({
        amount: 100.0,
        unit: 'lbs',
      }.to_json)
    end
  end
end
