# filename: app.rb
# desc: core class which controls the process (App.start)

require 'uri'
require 'open-uri'
require File.join(App::APPROOT,'/lib/mailgun.rb')
require File.join(App::APPROOT,'/lib/dropbox.rb')

class App
  class << self
    def init 
      @dropbox = Dbox.new({
        :app_key => App::DROPBOX_APP_KEY,
        :app_secret => App::DROPBOX_APP_SECRET,
        :access_token_file => App::DROPBOX_ACCESS_TOKEN_CACHE
      })

      @mail = Mailgun.new({
        :api_key => App::MAILGUN_API_KEY,
        :domain => App::MAILGUN_DOMAIN
      })
    end

    def start
      init() # setup Dropbox and Mailgun

      # stop if dropbox hasn't been authorized
      if not @dropbox.authorized?
        puts "Please authorize dropbox first."
        return
      end

      # get all the events, beginning from `time_latest` till now
      events = @mail.retrieve_events(:stored, time_latest)

      puts "Found " + events['items'].count.to_s + " new mail(s)"

      # get all stored messages
      messages = @mail.get_messages(events)

      # grab pdf url 
      pdfs = []
      messages.each do |message| 
        pdfs << extract_pdfs(message)
      end

      puts "Downloading files..." 
      dl_files = download(pdfs.flatten.compact)

      puts "Uploading to Dropbox..." 
      upload_to_dropbox(dl_files)

      puts "Deleting processed messages..." 
      @mail.delete_messages
      
      # save the time of latest event
      save_time_latest(events)
    end

    def save_time_latest events
      return if events['items'].empty?

      times = events['items'].map {|item| item['timestamp'] }
      times.sort! do |t1,t2|
        t2 <=> t1
      end
      latest = times.first + 1

      filepath = App::MAILGUN_LATEST_MAIL_TIME
      File.open(filepath, 'w') do |file|
        file.write(latest)
      end
    end

    def time_latest # return time of latest processed mail
      filepath = App::MAILGUN_LATEST_MAIL_TIME
      return nil unless (File.exist?(filepath) and File.file?(filepath))

      time = nil
      File.open(filepath, 'rb') do |file|
        time = file.gets.to_i
      end

      time
    end

    def extract_pdfs message
      pdfs = []
      content = message['stripped-text']

      URI.extract(content).each do |url|
        pdfs << {url: url, subject: message['subject']} if url =~ /\.pdf/
      end if content.is_a? String

      pdfs 
    end

    def download pdfs
      dir = App::FILE_DIR
      Dir.mkdir(dir) unless File.directory?(dir)
      files = []
      pdfs.each_index do |i|
        url = pdfs[i][:url]
        filename = make_filename(pdfs[i],i,dir)
        filepath = File.join(dir, filename)

        File.open(filepath, 'wb') do |file|
          # TODO: what if errors occurred?
          file << open(url).read
        end
        files << {filename: filename, filepath: filepath}
      end

      files
    end

    def upload_to_dropbox files
      @dropbox.upload(files) if @dropbox.authorized?
    end

    def make_filename(pdf,count,dir) # avoid duplicate
      ext = '.pdf'
      filename = pdf[:subject].gsub(/\s|\W/, '') + "_#{count+1}"
      filepath = File.join(dir,filename) + ext
      
      # check if file already existed, if so change filename
      copy_count = 1
      tmp_filename = nil
      while File.exist?(filepath)
        tmp_filename = filename + "(#{copy_count})" + ext
        filepath = File.join(dir,tmp_filename)
        copy_count += 1
      end
      filename = tmp_filename unless tmp_filename.nil? # new filename
      filename
    end

  end
end
