require 'rubygems'
require 'logger'
require 'sinatra'
require 'sinatra_more/markup_plugin'
require 'sinatra_more/render_plugin'
require 'dm-core'
require 'dm-timestamps'
require 'dm-pager'
require 'haml'
require 'rdiscount'

# Use sass's Rack integration
require 'sass/plugin/rack'
use Sass::Plugin::Rack

require 'app'

map '/' do
  run SinatraBlog
end
