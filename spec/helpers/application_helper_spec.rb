require "rails_helper"

describe ApplicationHelper do
  describe "#gravatar_for" do
    let(:user) { build(:user) }

    it "returns the gravatar image tag" do
      expected = "<img alt=\"#{user.username}\" " +
        "class=\"gravatar\" " +
        "src=\"https://secure.gravatar.com/avatar/" +
        "#{user.gravatar_id}?s=260&amp;d=mm\" />"
      expect(gravatar_for(user)).to eql(expected)
    end
  end
end
