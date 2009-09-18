require 'rubygems'
require 'sinatra'

set :environment, :production
set :app_file, 'app.rb'
set :run, false

require 'app'
run Sinatra::Application