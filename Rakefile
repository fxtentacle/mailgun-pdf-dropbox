namespace :app do
  desc "Run the app - check mails, download, upload"
  task :run do
    require_relative './run.rb'
  end
end

namespace :dropbox do
  desc "Login Dropbox before being able to upload files"
  task :login do
    require_relative './dropbox_login.rb'
  end
end

task :default => 'app:run'
