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
  end
end
