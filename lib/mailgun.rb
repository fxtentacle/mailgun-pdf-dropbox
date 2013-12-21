require 'rest-client'

class Mailgun

  def initialize api_key, domain
    @api_key, @domain = api_key, domain
  end

  def get_mail
  end

  def get_log
    RestClient.get events_url,
      :params => {
      :'limit'=>  25,
    }
  end
  
  private
  def base_url
    "https://api:#{@api_key}@api.mailgun.net/v2/"
  end

  def events_url
    "#{base_url}/#{@domain}/events"
  end

  def messages_url message_id
    "#{base_url}/domains/#{@domain}/messages/"
  end
end
