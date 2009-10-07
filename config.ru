require 'rubygems'
require 'sinatra'

set :environment, (ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development)
set :public,      File.expand_path(File.dirname(__FILE__) + '/public')
set :views,       File.expand_path(File.dirname(__FILE__) + '/views')
set :app_file,    'app.rb'
set :run,         false

require 'app'
run Sinatra::Application
