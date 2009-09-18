# libs
%w(rubygems sinatra datamapper haml sass).each do |lib|
  require lib
end

# routing / actions
get '/style.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :style
end