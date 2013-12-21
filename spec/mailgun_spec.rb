require 'webmock/rspec'
require_relative "../lib/mailgun.rb"

WebMock.disable_net_connect!(allow_localhost: true)

describe Mailgun do
  describe :get_messages do
    it 'should return an array of hashes' do
      events = '{ "items": [ { "storage":{ "url":"", "key":"" } } ] }'
      message = '{ "body-plain":"this is body","subject":"this is subject" }'
      
      Mailgun.any_instance.stub(:retrieve_events).and_return(events)
      Mailgun.any_instance.stub(:retrieve_message).and_return(message)
      Mailgun.new({:api_key => '', :domain => ''}).get_messages.should == [JSON.parse(message)]
    end
  end

  describe :retrieve_events do
    it 'should return correct events in JSON on a success request'
    it 'should ... on bad request ... more test add later, stub the external service takes more effort'
  end

  describe :retrieve_events do
    it 'should return correct message in JSON on a success request'
    it 'need to stub the external service to test this'
  end

  describe :retrieve_events do
    it 'should return correct message in JSON on a success request'
    it 'need to stub the external service to test this'
  end
end
