require 'rubygems'
require 'sinatra'

set :app_file, 'app.rb'
set :run, false
set :env, (ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :production)

require 'app'
run Sinatra::Application