require 'spec_helper'

describe Zoomus::Utils do

  before(:all) do
    class Utils < Zoomus::Utils; end
  end

  describe "#argument_error" do
    it "raises ArgumentError" do
      expect(Utils.argument_error("foo")).to be_instance_of(ArgumentError)
    end
  end

  describe "#raise_if_error!" do
    it "raises Zoomus::Error if error is present" do
      response = {'error' => { 'message' => 'lol error'}}
      expect{Utils.raise_if_error!(response)}.to raise_error(Zoomus::Error)
    end

    it "does not raise Zoomus::Error if error is not present" do
      response = {}
      expect{Utils.raise_if_error!(response)}.to_not raise_error
    end
  end

  describe "#require_params" do
    it "raises ArgumentError if the param is not present" do
      expect{Utils.require_params(:foo, {:bar => 'bar'})}.to raise_error(ArgumentError)
    end

    it "does not raise ArgumentError if the param is present" do
      expect{Utils.require_params(:foo, {:foo => 'foo'})}.to_not raise_error
    end
  end

  describe "#extract_options!" do
    it "converts array to hash options" do
      args = [{:foo => 'foo'}, {:bar => 'bar'}, {:zemba => 'zemba'}]
      expect(Utils.extract_options!(args)).to be_kind_of(Hash)
    end
  end

  describe "#parse_response" do
    context 'when http response has 200 status code' do
      let(:response) { double(HTTParty::Response, code: 200, parsed_response: { body: 'success' }) }

      it 'returns parsed_response' do
        expect(Utils.parse_response(response)).to eq({ body: 'success' })
      end
    end

    context 'when http response has 503 status code' do
      let(:response) { double(HTTParty::Response, code: 503) }

      it 'returns hash with error message' do
        expect(Utils.parse_response(response)).to eq({ 'error' => { 'message' => "API returned error code 503", 'code' => 503 } })
      end
    end

    context 'when http response does not have a status code' do
      it 'returns hash with error message' do
        expect(Utils.parse_response('error')).to eq({ 'error' => { 'message' => "Could not communicate with Zoom API", 'code' => 500 } })
      end
    end
  end


  describe "#process_datetime_params" do
    it "converts the Time objects to formatted strings" do
      args = {
        :foo => 'foo',
        :bar => Time.utc(2000, "jan", 1, 20, 15, 1)
      }
      expect(
        Utils.process_datetime_params!(:bar, args)
      ).to eq({:foo => 'foo',
               :bar => "2000-01-01T20:15:01Z"})
    end
  end
end
