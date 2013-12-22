require './config/config.rb'
require File.join(App::APPROOT,'/lib/app.rb') # core app class

puts "Starting app..."
App.start
