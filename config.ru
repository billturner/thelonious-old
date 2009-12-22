require 'rubygems'
require 'sinatra'

# Use sass's Rack integration
require 'sass/plugin/rack'
use Sass::Plugin::Rack

require 'app'
#run Sinatra::Application
SinatraBlog.run!
