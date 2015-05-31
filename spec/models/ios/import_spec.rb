require "rails_helper"

describe Ios::Import do
  subject { Ios::Import.new(user, program) }
  let(:user) { build(:user) }
  let(:program) { build(:program) }

  describe "#can_parse?" do
    let(:directory) { Dir.mktmpdir }

    context "when the directory contains the ios backup db" do
      before :each do
        FileUtils.touch("#{directory}/SLDB.sqlite")
      end

      it "returns true" do
        expect(subject.can_parse?(directory)).to be_truthy
      end
    end

    context "when the directory does not have the ios backup db" do
      it "returns false" do
        expect(subject.can_parse?(directory)).to be_falsey
      end
    end
  end
end
