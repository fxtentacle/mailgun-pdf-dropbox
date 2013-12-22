require 'dropbox_sdk'

# filename: dropbox.rb
# desc: contains methods for authorizing user (login)
#       and after that, upload files to Dropbox

class Dbox 
  def initialize params
    @app_key = params[:app_key]
    @app_secret = params[:app_secret]
    @access_token_file = params[:access_token_file]
    @access_token = load_access_token() # read from file
    @client = nil 
  end

  def authorized? # see if an access token has been load from a file
    !!@access_token
  end

  def authorize
    web_auth = DropboxOAuth2FlowNoRedirect.new(@app_key, @app_secret)
    authorize_url = web_auth.start()
    puts "1. Go to: #{authorize_url}"
    puts "2. Click \"Allow\" (you might have to log in first)."
    puts "3. Copy the authorization code."

    print "Enter the authorization code here: "
    STDOUT.flush
    auth_code = STDIN.gets.strip

    @access_token, user_id = web_auth.finish(auth_code)
    save_access_token()

    puts "You are now logged in."
  end

  # TODO: should some how log the file for later resume uploading if not authorized
  def upload files 
    return unless authorized?

    @client = DropboxClient.new(@access_token)
    files.each do |file_info|
      file = open(file_info[:filepath])
      response = @client.put_file(file_info[:filename], file)
      # TODO: log or do something with dropbox response 
    end
  end

  private
  def load_access_token
    filepath = @access_token_file
    return nil unless (File.exist?(filepath) and File.file?(filepath))
    
    access_token = ''
    File.open(filepath, 'rb') do |file|
      access_token << file.gets
    end
    access_token
  end

  def save_access_token
    filepath = @access_token_file  
    File.open(filepath, 'w') do |file|
      file.write @access_token
    end
  end

end
