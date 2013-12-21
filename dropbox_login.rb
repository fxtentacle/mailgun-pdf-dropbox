require './config/config.rb'
require './lib/dropbox.rb'

dropbox = Dbox.new({
  :app_key => App::DROPBOX_APP_KEY,
  :app_secret => App::DROPBOX_APP_SECRET,
  :access_token_file => App::DROPBOX_ACCESS_TOKEN_CACHE
})

dropbox.authorize
