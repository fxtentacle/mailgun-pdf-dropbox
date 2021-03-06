require 'webmock/rspec'
require_relative "../lib/mailgun.rb"

WebMock.disable_net_connect!(allow_localhost: true)

describe Mailgun do
  before(:each) do
    @test_events = { 'items'=> [ { 'storage'=>{ 'url'=>'', 'key'=>'' } } ] }
    @test_message = { 'stripped-text'=>'this is body','subject'=>'this is subject' }
  end

  describe :get_messages do
    it 'should return an array of hashes' do
      Mailgun.any_instance.stub(:retrieve_message).and_return(@test_message)
      Mailgun.new({:api_key => '', :domain => ''}).get_messages(@test_events).should == [@test_message]
    end
  end

  describe :retrieve_events do
    it 'should return correct events hash' do
      stub_request(:get, %r{https://api:.*@api.mailgun.net/v2/.*/events.*}).
          to_return(:status => 200, :body => @test_events.to_json, :headers => {})

      events = Mailgun.new({:api_key => '', :domain => ''}).retrieve_events(:stored)
      events.should == @test_events
    end
  end

  describe :retrieve_message do
    it 'should return correct message hash on a success request' do
      stub_request(:get, %r{https://api.mailgun.net/v2/domains/mydomain.com/messages/.*}).
          to_return(:status => 200, :body => @test_message.to_json, :headers => {})
      message = Mailgun.new({:api_key => '', :domain => ''}).retrieve_message('https://api.mailgun.net/v2/domains/mydomain.com/messages/WyJhOTM4NDk1ODA3Iiw')
      message.should == @test_message
    end
  end

  describe 'url helper' do
    before(:each) do
      @test_api = 'wevrnlsfLwEL24L67'
      @test_domain = 'example.com'
    end
  
    describe :base_url do
      it 'should return correct base url, given the api' do
        mail = Mailgun.new({:api_key => @test_api, :domain => @test_domain})
        mail.base_url.should == "https://api:#{@test_api}@api.mailgun.net/v2"
      end
    end
    describe :message_url do
      it 'should return correct message url, given the api' do
        test_key = 'somekeykeykey'
        mail = Mailgun.new({:api_key => @test_api, :domain => @test_domain})
        mail.message_url(test_key).should == "https://api:#{@test_api}@api.mailgun.net/v2/domains/#{@test_domain}/messages/#{test_key}"
 
      end
    end
    describe :events_url do
      it 'should return correct events url, given the api and domain' do
        Mailgun.any_instance.stub(:base_url).and_return("https://api:#{@test_api}@api.mailgun.net/v2")
        mail = Mailgun.new({:api_key => @test_api, :domain => @test_domain})
        mail.events_url.should == "https://api:#{@test_api}@api.mailgun.net/v2/#{@test_domain}/events"
      end
    end
  end

  describe :delete_messages do
    it 'should be tested!!!!!!!!'
  end

  it 'bad pathhhh'

end
