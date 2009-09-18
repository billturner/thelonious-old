# libs
%w(rubygems sinatra dm-core haml sass).each do |lib|
  require lib
end

require 'config/settings'

# routing / actions
get '/' do
  haml :index
end

get '/style.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :style
end