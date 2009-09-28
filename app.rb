# libs
%w(rubygems compass sinatra dm-core dm-timestamps haml rdiscount).each do |lib|
  require lib
end

# Set up db logging
DataMapper::Logger.new(STDOUT, :debug)

# config & db connection ( + models )
['config/settings.rb', 'config/database.rb'].each {|file| require file }

# a few helpers
helpers do

  def permalink_url(post)
    "#{BLOG_URL}/#{post.created_at.strftime('%Y/%m')}/#{post.slug}"
  end
  
  def tag_url(tag)
    "#{BLOG_URL}/tag/#{tag.slug}"
  end
  
  def page_url(page)
    "#{BLOG_URL}/page/#{page.slug}"
  end
  
  def markdown(text)
    RDiscount.new(text).to_html
  end  

  def cdata(text)
    "<![CDATA[#{text}]]>"
  end
  
  def cdata_and_escape(text)
    "<![CDATA[#{escape_html(text)}]]>"
  end
  
end

# errors
not_found do
  @page_title = "404 (Not Found)"
  haml :error404
end

# routing & actions
get '/' do 
  @posts = Post.recently_published
  @page_title = BLOG_DESCRIPTION
  haml :index
end

get "/:year/:month/:slug" do
  @post = Post.first(:slug => params[:slug])
  raise not_found unless @post
  @page_title = @post.title
  haml :post
end

get "/page/:slug" do
  @page = Page.first(:slug => params[:slug])
  raise not_found unless @page
  @page_title = @page.title
  haml :page
end

get "/tag/:slug" do
  @tag = Tag.first(:slug => params[:slug])
  raise not_found unless @tag
  @posts = @tag.posts(:published => true, :order => [:published_at.desc])
  haml :index
end

get "/rss/?" do
  content_type 'application/rss+xml', :charset => 'utf-8'
  @posts = Post.recently_published
  haml :rss, :layout => false
end

get '/robots.txt' do
  content_type 'text/plain', :charset => 'utf-8'
  'User-agent: *
Allow: /'
end

get '/sitemap.xml' do
  content_type 'text/xml', :charset => 'utf-8'
  @posts = Post.all
  @tags = Tag.all
  @pages = Page.all
  haml :sitemap, :layout => false
end

# stylesheet
get '/stylesheets/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :"stylesheets/style", :sass => Compass.sass_engine_options
end

## POSTS
# Add a new post
get '/new_post' do
  #authenticate
  @page_title = "Add Post"
  @post = Post.new
  haml :new_post
end
post '/new_post' do
  #authenticate
  @post = Post.create(params[:post])
  redirect '/'
end
# Edit existing post
get '/edit_post/:id' do
  #authenticate
  @page_title = "Edit Post"
  @post = Post.get(params[:id])
  haml :edit_post
end
post '/edit_post/:id' do
  #authenticate
  @post = Post.get(params[:id])
  @post.update(params[:post])
  redirect '/'
end

## PAGES
# Add a new page
get '/new_page' do
  #authenticate
  @page_title = "Add Page"
  @page = Page.new
  haml :new_page
end
post '/new_page' do
  #authenticate
  @page = Page.create(params[:page])
  redirect '/'
end

# Edit existing page
get '/edit_page/:id' do
  #authenticate
  @page_title = "Edit Page"
  @page = Page.get(params[:id])
  haml :edit_page
end
post '/edit_page/:id' do
  #authenticate
  @page = Page.get(params[:id])
  @page.update(params[:page])
  redirect '/'
end
