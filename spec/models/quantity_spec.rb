require 'spec_helper'

describe Quantity do
  describe "#to" do
    it 'converts lbs to kgs' do
      lbs = Quantity.new(135.0, :lbs)
      expect(lbs.to(:kg).to_f.round(1)).to eql(61.2)
    end

    it 'converts kgs to kgs' do
      kgs = Quantity.new(135.0, :kgs)
      expect(kgs.to(:kgs).to_f).to eql(135.0)
    end

    it 'converts kgs to lbs' do
      kgs = Quantity.new(61.2, :kgs)
      expect(kgs.to(:lbs).to_f.round(0)).to eql(135)
    end

    it 'converts lbs to lbs' do
      lbs = Quantity.new(135.0, :lbs)
      expect(lbs.to(:lbs).to_f).to eql(135.0)
    end
  end

  describe "#eql?" do
    it 'is equal when both are lbs' do
      quantity = Quantity.new(135.0, :lbs)
      other = Quantity.new(135.0, :lbs)
      expect(quantity).to eql(other)
    end

    it 'is equal when both are kgs' do
      quantity = Quantity.new(61.2, :kgs)
      other = Quantity.new(61.2, :kgs)
      expect(quantity).to eql(other)
    end

    it 'is equal when different units' do
      quantity = Quantity.new(135.0, :lbs)
      other = Quantity.new(61.2, :kgs)
      expect(quantity).to eql(other)
    end

    it 'is equal to a float' do
      quantity = Quantity.new(135.0, :lbs)
      expect(quantity).to eql(135.0)
    end

    it 'is not equal' do
      quantity = Quantity.new(135.0, :lbs)
      other = Quantity.new(135.2, :lbs)
      expect(quantity).to_not eql(other)
    end
  end

  describe "#+" do
    it 'adds lbs to lbs' do
      quantity = Quantity.new(135.0, :lbs)
      other = Quantity.new(135.0, :lbs)
      expect(quantity + other).to eql(Quantity.new(270.0, :lbs))
    end

    it 'adds kgs to lbs' do
      quantity = Quantity.new(135.0, :lbs)
      other = Quantity.new(61.2, :kg)
      expect(quantity + other).to eql(Quantity.new(270.0, :lbs))
    end

    it 'adds lbs to kgs' do
      quantity = Quantity.new(61.2, :kg)
      other = Quantity.new(135.0, :lbs)
      expect(quantity + other).to eql(Quantity.new(122.4, :kg))
    end

    it 'adds a float to lbs' do
      quantity = Quantity.new(135.0, :lbs)
      other = 135.0
      expect(quantity + other).to eql(Quantity.new(270.0, :lbs))
    end
  end
end
