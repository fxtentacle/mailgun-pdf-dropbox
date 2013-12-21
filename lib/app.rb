require 'uri'
require 'open-uri'
require_relative 'mailgun.rb'

class App
  # Configurations
  MAIL_API_KEY = 'key-21ayc-i-p20k9aw9gcg2toueux58r2p4'   
  MAIL_DOMAIN = 'sandbox10211.mailgun.org'

  class << self
    def start
      mail = Mailgun.new(MAIL_API_KEY, MAIL_DOMAIN)
      # retrieve all stored messages
      messages = mail.get_messages

      # perform grab link, download, upload to Dropbox
      messages.each do |message| 
        body = message['body-plain']
        subject = message['subject']
        pdf_urls = extract_pdf_links(body)
        @dl_files = download(@pdf_urls, subject)
      end
    end

    # should be private but public make testing easier
    def download urls, subject 
      puts urls
    end

    def extract_pdf_links content
      urls = URI.extract(content).select do |url|
        url if url =~ /\.pdf/
      end if body.is_a? String
    end

  end
end

App.start
