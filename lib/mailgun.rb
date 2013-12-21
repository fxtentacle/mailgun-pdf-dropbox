require 'rest-client'

class Mailgun # TODO: need to handle exceptions, e.g API Requests error, Bad request...
  def initialize params
    @api_key = params[:api_key]  
    @domain = params[:domain]  
  end

  # returns all stored messages as an array of hash
  def get_messages 
    events = JSON.parse(retrieve_events(:stored))
    msg_urls = events['items'].map do |item|
      item['storage']['url']
    end

    messages = msg_urls.map do |url|
      JSON.parse retrieve_message(url)
    end

    messages
  end

  def retrieve_events type
    RestClient.get events_url, :params => {
      :event => type.to_s
    }
  end

  def retrieve_message url
    RestClient.get url
  end

  def base_url
    "https://api:#{@api_key}@api.mailgun.net/v2"
  end

  def events_url
    "#{base_url}/#{@domain}/events"
  end
end
