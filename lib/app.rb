require_relative 'mailgun.rb'

class App
  # Move to configuration later
  API_KEY = 'key-21ayc-i-p20k9aw9gcg2toueux58r2p4'   
  PUB_API_KEY = 'pubkey-3rgvyp7zd408o3y1e179halm4w3pbqu9'
  DOMAIN = 'sandbox10211.mailgun.org'

  class << self
    def start
      mail = Mailgun.new(API_KEY, DOMAIN)
      puts JSON.parse(mail.get_log).keys
    end
  end
end

App.start
