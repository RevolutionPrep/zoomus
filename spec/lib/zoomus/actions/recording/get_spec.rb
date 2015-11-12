require 'spec_helper'

describe Zoomus::Actions::Recording do

  before :all do
    @zc = zoomus_client
    @args = {
      :meeting_id => "123456789"
    }
  end

  describe "#recording_get action" do
    before :each do
      stub_request(
        :post,
        zoomus_url("/recording/get")
      ).to_return(:body => json_response("recording_get"))
    end

    it "requires a 'meeting_id' argument" do
      expect {
        @zc.meeting_create(filter_key(@args, :meeting_id))
      }.to raise_error(ArgumentError)
    end

    it "returns a hash" do
      expect(@zc.recording_get(@args)).to be_kind_of(Hash)
    end

    it "returns attributes" do
      res = @zc.recording_get(@args)

      expect(res["recording_files"]).to be_kind_of(Array)
      expect(res["recording_count"]).to eq(3)
    end
  end

  describe "#recording_get! action" do
    before :each do
      stub_request(
        :post,
        zoomus_url("/recording/get")
      ).to_return(:body => json_response("error"))
    end

    it "raises Zoomus::Error exception" do
      expect {
        @zc.recording_get!(@args)
      }.to raise_error(Zoomus::Error)
    end
  end
end
