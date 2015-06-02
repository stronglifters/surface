require "rails_helper"

describe Program do
  it "saves a slug" do
    program = create(:program, name: "Strong Lifts 5x5")
    expect(program.slug).to eql("strong-lifts-5x5")
  end

  describe ".stronglifts" do
    include_context "stronglifts_program"

    it "returns the stronglifts program" do
      expect(Program.stronglifts).to eql(program)
    end
  end
end
