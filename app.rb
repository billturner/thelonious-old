# libs
%w(rubygems sinatra dm-core dm-timestamps haml sass rdiscount).each do |lib|
  require lib
end

# temporarily here:
set :environment, (ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development)

# Set up db logging
DataMapper::Logger.new(STDOUT, :debug)

# config & db connection ( + models )
['config/settings.rb', 'config/database.rb'].each {|file| require file }

# a few helpers
helpers do

  def permalink_url(post)
    "#{BLOG_URL}/#{post.created_at.strftime('%Y/%m')}/#{post.slug}"
  end
  
  def markdown(text)
    RDiscount.new(text).to_html
  end
  
end

# routing & actions
get '/' do 
  @posts = Post.all
  @page_title = "Weblog Posts"
  haml :index
end

get "/:year/:month/:slug" do
  @post = Post.first(:slug => params[:slug])
  @page_title = @post.title
  haml :view
end

# stylesheet
get '/style.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :style
end

# Add a new post
get '/new' do
  @page_title = "Add Post"
  @post = Post.new
  haml :new
end
post '/new' do
  @post = Post.create(params[:post])
  redirect '/'
end

# Edit existing post
get '/edit/:id' do
  @page_title = "Edit Post"
  @post = Post.get(params[:id])
  haml :edit
end
post '/edit/:id' do
  @post = Post.get(params[:id])
  @post.update(params[:post])
  redirect '/'
end
