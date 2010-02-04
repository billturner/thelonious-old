require 'rubygems'
require 'sinatra'
require 'spec'
require 'webrat'
require 'spec/interop/test'
require 'rack/test'
require 'factory_girl'

# set test environment
Sinatra::Base.set :environment, :test
Sinatra::Base.set :run, false
Sinatra::Base.set :raise_errors, true
Sinatra::Base.set :logging, false

# bring in the app file
require File.join(File.dirname(__FILE__), '..', 'app')

def app
  #@app ||= SinatraBlog
  Sinatra::Application
end

Webrat.configure do |config|
  config.mode = :rack
end

Spec::Runner.configure do |config|
  config.include Rack::Test::Methods
  config.include Webrat::Methods
  config.include Webrat::Matchers
end
