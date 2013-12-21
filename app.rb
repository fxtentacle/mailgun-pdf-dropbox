require 'uri'
require 'open-uri'
require 'dropbox_sdk'
require './config/config.rb'
require './lib/mailgun.rb'
require './lib/dropbox.rb'

class App

  class << self
    def start
      Mailgun.configuration({:api_key => App::MAILGUN_API_KEY, :domain => App::MAILGUN_DOMAIN})

      # retrieve all stored messages
      # messages = Mailgun.get_messages #TODO: stub suck
      messages = [{'body-plain' => 'asfd sdaf http://www.relacweb.org/menuconferencia/menu/manual-memorias.pdf sdljfi', 'subject' => "This is a nice $#^&day"}]

      # perform grab link, download, upload to Dropbox
      messages.each do |message| 
        body = message['body-plain']
        subject = message['subject']
        pdf_urls = extract_pdf_urls(body)

        dl_files = download(pdf_urls, subject)
        # upload_to_dropbox(dl_files)
      end
    end

    def extract_pdf_urls content
      urls = URI.extract(content).select do |url|
        url if url =~ /\.pdf/
      end if content.is_a? String

      urls
    end

    def download urls, subject 
      dir = App::FILE_DIR
      Dir.mkdir(dir) unless File.directory?(dir)
      files = []
      urls.each_index do |i| # TODO: if filename duplicate?
        filename = subject.gsub(/\s|\W/, '') + "_#{i}.pdf"
        filepath = File.join(dir, filename)

        File.open(filepath, 'wb') do |file|
          # TODO: what errors could occur?
          file << open(urls[i]).read
        end
        files << {filename: filename, filepath: filepath}
      end

      files
    end

    def upload_to_dropbox files
      dropbox = Dbox.new({
        :app_key => App::DROPBOX_APP_KEY,
        :app_secret => App::DROPBOX_APP_SECRET
      })
      dropbox.upload(files) if dropbox.authorized?
    end

  end
end

App.start
