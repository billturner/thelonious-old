require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "RSS Feed Tests" do

  before(:each) do
    @browser = Rack::Test::Session.new(Rack::MockSession.new(app, test_domain))
    Post.delete_all
  end

  it "should respond successfully" do
    @browser.get '/rss'
    res.should be_ok
  end

  it "should return the correct content-type when viewing the RSS feed" do
    @browser.get '/rss'
    res.headers["Content-Type"].should contain("application/rss+xml")
  end

  it "should have the basic channel information" do
    @browser.get '/rss'
    body.should have_selector("channel")
    body.should have_selector("channel > title", :content => BLOG_TITLE)
    #body.should have_selector("channel > description", :content => "#{Rack::Utils.escape_html(BLOG_DESCRIPTION)}")
  end
  
  it "should not have any <item>s if there are no posts" do
    @browser.get '/rss'
    body.should_not have_selector("item")
  end

  it "should have the correct number of <item>s" do
    Factory.create(:post)
    @browser.get '/rss'
    body.should have_selector("item", :count => 1)
    # create another post
    Factory.create(:post, :title => "This is another post", :body => "Some more bogus copy")
    @browser.get "/rss"
    body.should have_selector("item", :count => 2)
    # create another post, but leave unpublished
    Factory.create(:post, :title => "This post is unpublished", :body => "Body to be filled in later", :published => false)
    @browser.get "/rss"
    body.should have_selector("item", :count => 2)
  end

end
