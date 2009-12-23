class SinatraBlog < Sinatra::Application

  # views & public
  set :public, File.join(File.dirname(__FILE__), 'public')
  set :views, File.join(File.dirname(__FILE__), 'views')
  
  # Sass via Rack settings
  Sass::Plugin.options[:css_location] = File.join(SinatraBlog.public, 'stylesheets')
  Sass::Plugin.options[:template_location] = File.join(SinatraBlog.public, 'stylesheets', 'sass')
  
  # allow sessions
  enable :sessions

  # log datamapper queries
  DataMapper::Logger.new(STDOUT, :debug) if development?

  # haml settings
  set :haml, { :attr_wrapper => '"' }

  register SinatraMore::MarkupPlugin
  register SinatraMore::RenderPlugin
  
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

    def authenticate!
      redirect '/login' unless logged_in?
    end

    def logged_in?
      session[:user]
    end

  end

  # errors
  not_found do
    @page_title = "404 (Not Found)"
    haml :error404
  end

  # routing & actions
  get '/' do
    page_number = params[:page] || 1
    @posts = Post.page(page_number, :per_page => POSTS_PER_PAGE, :published => true, :order => [:published_at.desc])
    @page_title = BLOG_DESCRIPTION
    haml :index
  end

  get "/:year/:month/:slug" do
    @post = Post.first(:slug => params[:slug])
    raise not_found unless @post
    @page_title = @post.title
    haml :post, :locals => { :post => @post }
  end

  get '/archive' do
    @page_title = 'Archived Posts'
    haml :archive
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
    raise not_found unless @posts
    @page_title = "All posts tagged with ##{@tag.name}"
    haml :index
  end

  get "/rss" do
    content_type 'application/rss+xml', :charset => 'utf-8'
    haml :rss, :layout => false
  end

  get '/sitemap.xml' do
    content_type 'text/xml', :charset => 'utf-8'
    haml :sitemap, :layout => false
  end

  ## AUTHENTICATION STUFF
  get '/login' do
    @page_title = 'Please log in'
    haml :login
  end
  post '/login' do
    if params[:login][:username] == LOGIN_USERNAME && params[:login][:password] == LOGIN_PASSWORD
      session[:user] = LOGIN_USERNAME
      redirect '/'
    else
      redirect '/login'
    end
  end
  get '/logout' do
    session[:user] = nil
    redirect '/'
  end

  ## POSTS
  # Add a new post
  get '/new_post' do
    authenticate!
    @page_title = "Add Post"
    @post = Post.new
    haml :new_post
  end
  post '/new_post' do
    authenticate!
    @post = Post.create(params[:post])
    redirect '/'
  end
  # Edit existing post
  get '/edit_post/:id' do
    authenticate!
    @page_title = "Edit Post"
    @post = Post.get(params[:id])
    haml :edit_post
  end
  post '/edit_post/:id' do
    authenticate!
    @post = Post.get(params[:id])
    @post.update(params[:post])
    redirect '/all_posts'
  end
  get '/all_posts' do
    authenticate!
    @page_title = "All Posts"
    haml :all_posts
  end

  ## PAGES
  # Add a new page
  get '/new_page' do
    authenticate!
    @page_title = "Add Page"
    @page = Page.new
    haml :new_page
  end
  post '/new_page' do
    authenticate!
    @page = Page.create(params[:page])
    redirect '/all_pages'
  end
  get '/all_pages' do
    authenticate!
    @page_title = "All Pages"
    haml :all_pages
  end

  # Edit existing page
  get '/edit_page/:id' do
    authenticate!
    @page_title = "Edit Page"
    @page = Page.get(params[:id])
    haml :edit_page
  end
  post '/edit_page/:id' do
    authenticate!
    @page = Page.get(params[:id])
    @page.update(params[:page])
    redirect '/all_pages'
  end

end
