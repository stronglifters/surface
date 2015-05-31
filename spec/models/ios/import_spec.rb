require "rails_helper"

describe Ios::Import do
  include_context "stronglifts_program"
  subject { Ios::Import.new(user, program) }
  let(:user) { create(:user) }

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

  describe "#import_from" do
    let(:directory) { Dir.mktmpdir }
    let(:backup_file) { Rails.root.join("spec", "fixtures", "backup.ios.stronglifts") }

    before :each do
      `unzip #{backup_file} -d #{directory}`
    end

    after :each do
      FileUtils.remove_entry(directory)
    end

    it "imports each workout" do
      subject.import_from(directory)
      expect(user.training_sessions.count).to eql(9)
    end
  end
end
