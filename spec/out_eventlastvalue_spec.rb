require 'spec_helper'

describe Fluent::EventLastValueOutput do
  before { Fluent::Test.setup }


  describe '#format' do
    let (:conf) {
      %[
        emit_to output.lastvalue
        id_key id
        last_value_key count
      ]
    }
    let (:eventlastvalue) { Fluent::Test::BufferedOutputTestDriver.new(Fluent::EventLastValueOutput.new).configure(conf) }
    context 'the input contains the last_value key' do
      it 'produces the expected output' do
        eventlastvalue.tag = 'something'
        eventlastvalue.emit( { 'id' => '4444', 'count' => 12345 }, Time.now )
        eventlastvalue.expect_format ["4444", 12345].to_json + "\n"
        eventlastvalue.run
      end
    end

    context 'the input does not contain the last_value_key' do
      it 'does not add it to the buffer' do
        eventlastvalue.tag = 'something'
        eventlastvalue.emit( { 'not_last_value_key' => 12345}, Time.now )
        eventlastvalue.expect_format ''
        eventlastvalue.run
      end
    end
  end

  describe 'output' do
    let (:conf) {
      %[
        emit_to output.lastvalue
        id_key input_id
        last_value_key count
      ]
    }
    let (:input) {
      %[{"email": "john.doe@example.com", "count": 12345, "timestamp": "1337197600", "input_id": "1234"}
        {"email": "john.doe@example.com", "count": 12346, "timestamp": "1337966815", "input_id": "1234"}
        {"email": "john.doe@example.com", "count": 12344, "timestamp": "1337969592", "input_id": "1234"}
        {"email": "john.doe@example.com", "count": 12342, "timestamp": "1337197600", "input_id": "1234"}
        {"email": "john.doe@example.com", "count": 12349, "timestamp": "1337966815", "input_id": "1234"}
        {"email": "john.doe@example.com", "count": 12340, "timestamp": "1337969592", "input_id": "1234"}]
    }
    let (:eventlastvalue) { Fluent::Test::BufferedOutputTestDriver.new(Fluent::EventLastValueOutput.new).configure(conf) }

    it "formats the lastvalue against the provided tag" do
      input.split("\n").each do |line|
        data = JSON.parse line
        eventlastvalue.emit data, Time.now
      end
      output = eventlastvalue.run
      expect(output['1234']).to eq 12340
    end
  end
end
