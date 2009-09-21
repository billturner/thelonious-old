require 'rubygems'
require 'sinatra'

set :environment, (ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development)
set :app_file, 'app.rb'
set :run, false

require 'app'
run Sinatra::Application
