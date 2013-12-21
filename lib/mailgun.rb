require 'rest-client'

class Mailgun # TODO: need to handle exceptions, e.g API Requests error, Bad request...
  def initialize api_key, domain
    @api_key, @domain = api_key, domain
  end

  # send request message to get stored message, given message url as argument
  def get_messages 
    events = JSON.parse(get_events(:stored))
    msg_urls = events['items'].map do |item|
      item['storage']['url']
    end

    messages = msg_urls.map do |url|
      JSON.parse(RestClient.get url)
    end

    messages
  end


  private
  def get_events type
    RestClient.get events_url, :params => {
      :event => type.to_s
    }
  end
  
  def base_url
    "https://api:#{@api_key}@api.mailgun.net/v2"
  end

  def events_url
    "#{base_url}/#{@domain}/events"
  end

  # def messages_url message_id
  #   "#{base_url}/domains/#{@domain}/messages/#{message_id}"
  # end
end
