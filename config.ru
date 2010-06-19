require 'rubygems'
require 'sinatra'
require 'sinatra_more/markup_plugin'
require 'sinatra_more/render_plugin'
require 'mongo_mapper'
require 'haml'
require 'rdiscount'
require 'active_support/values/time_zone'
require 'rack-flash'

require 'thelonious'

map '/' do
  run Thelonious
end
