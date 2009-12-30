require 'rubygems'
require 'sinatra'
require 'spec'
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
 
# establish in-memory database for testing
DataMapper.setup(:default, "sqlite3::memory:")
# DataMapper::Logger.new(STDOUT, :debug) # uncomment to see all the Datamapper logs

Spec::Runner.configure do |config|
  # reset database before each example is run
  config.before(:each) { DataMapper.auto_migrate! }
end
