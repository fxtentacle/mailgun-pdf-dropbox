require 'uri'
require 'open-uri'
require File.join(App::APPROOT,'/lib/mailgun.rb')
require File.join(App::APPROOT,'/lib/dropbox.rb')

# filename: app.rb
# desc: core class which controls the process (App.start)

class App
  class << self
    def start
      mail = Mailgun.new({:api_key => App::MAILGUN_API_KEY, :domain => App::MAILGUN_DOMAIN})
      
      # retrieve all stored messages
      messages = mail.get_messages

      # perform grab link, download, upload to Dropbox
      messages.each do |message| 
        body = message['body-plain']
        subject = message['subject']
        pdf_urls = extract_pdf_urls(body)
        
        # TODO: need pull these thing out of a loop
        dl_files = download(pdf_urls, subject)
        upload_to_dropbox(dl_files)
      end

      # delete processed messages
      puts "Deleteing old messages..." 
      mail.delete_messages
    end

    def extract_pdf_urls content
      urls = []
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
        :app_secret => App::DROPBOX_APP_SECRET,
        :access_token_file => App::DROPBOX_ACCESS_TOKEN_CACHE
      })
      dropbox.upload(files) if dropbox.authorized?
    end

    def say_hello
      File.open('/home/hieusun/programming/projects/mailgun_pdf/test.txt', 'a') do |file|
        file.puts("Hello....")
      end
    end

  end
end

# for testing
# messages = [{'body-plain' => 'asdf  asfd sdaf http://www.axmag.com/download/pdfurl-guide.pdf http://www.relacweb.org/menuconferencia/menu/manual-memorias.pdf sdljfi', 'subject' => "This is a nice $#^&day"}]
