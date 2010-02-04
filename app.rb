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

class SinatraBlog < Sinatra::Application

  # views & public
  set :public, File.join(File.dirname(__FILE__), 'public')
  set :views, File.join(File.dirname(__FILE__), 'views')
  set :lib, File.join(File.dirname(__FILE__), 'lib')

  # Sass via Rack settings
  Sass::Plugin.options[:css_location] = File.join(SinatraBlog.public, 'stylesheets')
  Sass::Plugin.options[:template_location] = File.join(SinatraBlog.public, 'stylesheets', 'sass')

  # allow sessions
  use Rack::Session::Cookie

  # turn off extra logging
  disable :logging

  # haml settings
  set :haml, { :attr_wrapper => '"' }

  register SinatraMore::MarkupPlugin
  register SinatraMore::RenderPlugin

  # config & db connection ( + models )
  require 'config/settings'
  require 'lib/database'

  # Set time zone
  Time.zone = TIME_ZONE
  
  # a few helpers
  helpers do

    # TODO: set up some sort of flash[] system (or rack-flash?)

    def permalink_url(post)
      "#{BLOG_URL}/#{post.created_at.strftime('%Y/%m')}/#{post.slug}"
    end

    def tag_url(tag)
      "#{BLOG_URL}/tag/#{Rack::Utils.escape(tag)}"
    end

    def page_url(page)
      "#{BLOG_URL}/page/#{page.slug}"
    end

    def markdown(text)
      RDiscount.new(text, :smart).to_html
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

    def creation_form?
      ['/new_post', '/new_page'].include?(request.path_info)
    end

  end

  # errors
  not_found do
    @page_title = "404 (Not Found)"
    haml :error404
  end

  # routing & actions
  get '/' do
    @posts = Post.paginate({ :per_page => POSTS_PER_PAGE, :page => params[:page] || 1, :order => "published_at DESC", :published => true })
    @page_title = BLOG_DESCRIPTION
    haml :index
  end

  get "/tag/:tag" do
    @posts = Post.paginate({ :per_page => POSTS_PER_PAGE, :page => params[:page] || 1, :order => "published_at DESC", :conditions => {:tags => [Rack::Utils.unescape(params[:tag])], :published => true }} )
    raise not_found unless @posts.length > 0
    @page_title = "All posts tagged with ##{params[:tag]}"
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
    @posts = Post.all(:published => true, :order => "published_at DESC")
    @tags = Post.all_tags(:published => true).flatten.compact.uniq
    haml :archive
  end

  get "/page/:slug" do
    @page = Page.first(:slug => params[:slug])
    raise not_found unless @page
    @page_title = @page.title
    haml :page
  end

  get "/rss" do
    content_type 'application/rss+xml', :charset => 'utf-8'
    haml :rss, :layout => false
  end

  get '/sitemap.xml' do
    content_type 'text/xml', :charset => 'utf-8'
    @posts = Post.all(:published => true, :order => "published_at DESC")
    @tags = Post.all_tags(:published => true).flatten.compact.uniq
    @pages = Page.all
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
    haml :post_form
  end
  # TODO: 1) Fix redirect; 2) force back to edit if errors
  post '/new_post' do
    authenticate!
    @post = Post.create(params[:post])
    redirect '/'
  end
  # Edit existing post
  get '/edit_post/:id' do
    authenticate!
    @page_title = "Edit Post"
    @post = Post.find(params[:id])
    haml :post_form
  end
  post '/edit_post/:id' do
    authenticate!
    @post = Post.find(params[:id])
    @post.update_attributes(params[:post])
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
    haml :page_form
  end
  # TODO: 1) Fix redirect; 2) force back to edit if errors
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
    @page = Page.find(params[:id])
    haml :page_form
  end
  post '/edit_page/:id' do
    authenticate!
    @page = Page.find(params[:id])
    @page.update_attributes(params[:page])
    redirect '/all_pages'
  end

end
