require "rails_helper"

describe UserSession do
  subject { build(:user_session) }

  describe "#revoke!" do
    it "records the time the session was revoked" do
      subject.revoke!
      expect(subject.revoked_at).to_not be_nil
    end
  end

  describe "#access" do
    let(:request) { double(ip: '192.168.1.1', user_agent: 'blah') }
    let(:location) { build(:location) }
    let(:because) {  subject.access(request) }

    before :each do
      allow(Location).to receive(:build_from_ip).with('192.168.1.1').and_return(location)
      because
    end

    it { expect(subject.accessed_at).to_not be_nil }
    it { expect(subject.ip).to eql(request.ip) }
    it { expect(subject.user_agent).to eql(request.user_agent) }
    it { expect(subject.location).to_not be_nil }
    it { expect(because).to eql(subject.id) }
    it { expect(subject).to be_persisted }
  end

  describe ".active" do
    let!(:active_session) { create(:user_session, accessed_at: Time.now) }
    let!(:expired_session) { create(:user_session, accessed_at: 15.days.ago) }
    let!(:revoked_session) { create(:user_session, accessed_at: 1.day.ago, revoked_at: Time.now) }

    it "returns active sessions" do
      expect(UserSession.active).to include(active_session)
    end

    it "excludes expired sessions" do
      expect(UserSession.active).to_not include(expired_session)
    end

    it "excludes revoked sessions" do
      expect(UserSession.active).to_not include(revoked_session)
    end
  end

  describe ".authenticate" do
    let!(:active_session) { create(:user_session, accessed_at: Time.now) }

    it "returns the session if the id is active" do
      expect(UserSession.authenticate(active_session.id)).to eql(active_session)
    end

    it "returns nil if the id is not active" do
      expect(UserSession.authenticate('blah')).to be_nil
    end
  end
end
