require 'rubygems'
require 'sinatra'
require 'sinatra_more/markup_plugin'
require 'sinatra_more/render_plugin'
require 'mongo_mapper'
require 'haml'
require 'rdiscount'
require 'active_support/values/time_zone'

# Use sass's Rack integration
require 'sass/plugin/rack'
use Sass::Plugin::Rack

require 'app'

map '/' do
  run SinatraBlog
end
