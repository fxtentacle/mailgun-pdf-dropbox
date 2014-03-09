require 'rest-client'

# filename: mailgun.rb
# desc: contains some methods contacting the Mailgun API
#       and parsing the result

class Mailgun # TODO: handle exceptions !!!!!!
  def initialize params
    @api_key = params[:api_key]  
    @domain = params[:domain]  
    @msg_urls = []
  end

  # returns all stored messages as an array of hash
  def get_messages events

    @msg_keys = events['items'].map do |item|
      item['storage']['key'] if item['event'] == 'stored'
    end

    messages = @msg_keys.map do |key|
      retrieve_message(key)
    end

    messages
  end

  def delete_messages 
    @msg_keys.each do |key|
      RestClient.delete message_url(key)
    end
  end
  
  def send_report(to, subj, body) 
    RestClient::Request.new(
              :method => :post,
              :url => messages_url,
              :user => "api",
              :password => @api_key,
              :payload => {:to => to, :subject => subj, :text => body, :from => "system@automate.hajo.me"}
            ).execute
  end

  def retrieve_events(type,from=nil)
    params = {}
    params[:event] = type.to_s
    params[:end] = from if from != nil

    JSON.parse(RestClient.get(events_url, :params => params))
  end

  def retrieve_message msg_key
    JSON.parse(RestClient.get message_url(msg_key))
  end

  def base_url
    "https://api:#{@api_key}@api.mailgun.net/v2"
  end

  def message_url msg_key
    "https://api:#{@api_key}@api.mailgun.net/v2/domains/#{@domain}/messages/#{msg_key}"
  end
  
  def messages_url
    "https://api.mailgun.net/v2/#{@domain}/messages"
  end
  
  def events_url
    "#{base_url}/#{@domain}/events"
  end
end
