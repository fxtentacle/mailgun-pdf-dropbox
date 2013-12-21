class Dbox 
  def initialize params
    @app_key = params[:app_key]
    @app_secret = params[:app_secret]
    @access_token = nil # read from file
    @client = nil 
  end

  def authorized?
    !!@access_token
  end

  def authorize
    web_auth = DropboxOAuth2FlowNoRedirect.new(APP_KEY, APP_SECRET)
    authorize_url = web_auth.start()
    puts "1. Go to: #{authorize_url}"
    puts "2. Click \"Allow\" (you might have to log in first)."
    puts "3. Copy the authorization code."

    print "Enter the authorization code here: "
    STDOUT.flush
    auth_code = STDIN.gets.strip

    access_token, user_id = web_auth.finish(auth_code)

    @client = DropboxClient.new(access_token)
    puts "You are logged in.  Your access token is #{access_token}."
  end

  def upload files
    return unless authorized?
  end

end
