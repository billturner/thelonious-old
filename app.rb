# libs
%w(rubygems sinatra dm-core haml sass rdiscount).each do |lib|
  require lib
end

# temporarily here:
set :environment, (ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :production)

# Set up db logging
DataMapper::Logger.new(STDOUT, :debug)

# config & db connection ( + models )
['config/settings.rb', 'config/database.rb'].each {|file| require file }

# routing & actions
get '/' do
  @page_title = "Weblog Posts"
  @posts = Post.all
  haml :index
end

# stylesheet
get '/style.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :style
end

# viewing a post
get '/post/:id' do
  @post = Post.first(:slug => params[:id])
  haml :post
end