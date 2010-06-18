require 'rubygems'
require 'sinatra'
require 'spec'
require 'webrat'
require 'spec/interop/test'
require 'rack/test'
require 'factory_girl'

# bring in the app file
require File.join(File.dirname(__FILE__), '..', 'thelonious')

# Get Factories
Factory.find_definitions

# force test db
MongoMapper.database = 'thelonious_test'

# set test environment
Thelonious.set :environment, :test
Thelonious.set :run, false
Thelonious.set :raise_errors, true
Thelonious.set :logging, false

Webrat.configure do |config|
  config.mode = :rack
end

module RequestSpecHelper

  def login!
    @browser.post '/login', { "login[username]" => LOGIN_USERNAME, "login[password]" => LOGIN_PASSWORD }
  end

  def body
    @browser.last_response.body
  end

  def res
    @browser.last_response
  end

  def test_domain
    "#{BLOG_URL}".gsub(/http\:\/\//, '')
  end

end

Spec::Runner.configure do |config|

  def app
    @app ||= Thelonious
  end

  config.include Rack::Test::Methods
  config.include Webrat::Methods
  config.include Webrat::Matchers
  config.include Webrat::HaveTagMatcher
  config.include Thelonious::Helpers
  config.include RequestSpecHelper

end
