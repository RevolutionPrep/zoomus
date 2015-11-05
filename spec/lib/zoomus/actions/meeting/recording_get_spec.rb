require 'spec_helper'

describe Zoomus::Actions::Meeting do

  before :all do
    @zc = zoomus_client
    @args = {:meeting_id => "166651673"}
  end

  describe "#meeting_recording_get action" do
    before :each do
      stub_request(
        :post,
        zoomus_url("/recording/get")
      ).to_return(:body => json_response("meeting_recording_get"))
    end

    it "requires a 'meeting_id' argument" do
      expect{@zc.meeting_recording_get}.to raise_error(ArgumentError)
    end

    it "returns a hash" do
      expect(@zc.meeting_recording_get(@args)).to be_kind_of(Hash)
    end

    it "returns 'recording_count'" do
      expect(@zc.meeting_recording_get(@args)["recording_count"]).to eq(3)
    end

    it "returns 'recording_files' Array" do
      expect(@zc.meeting_recording_get(@args)["recording_files"]).to be_kind_of(Array)
    end
  end

  describe "#meeting_recording_get! action" do
    before :each do
      stub_request(
        :post,
        zoomus_url("/recording/get")
      ).to_return(:body => json_response("error"))
    end

    it "raises Zoomus::Error exception" do
      expect {
        @zc.meeting_recording_get!(@args)
      }.to raise_error(Zoomus::Error)
    end
  end
end
