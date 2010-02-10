require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "General View / Controller Spec" do

  before(:each) do
    @browser = Rack::Test::Session.new(Rack::MockSession.new(app, test_domain))
  end

  it "should respond to /" do
    @browser.get '/'
    res.should be_ok
  end

  it "should return the correct content-type when viewing root" do
    @browser.get '/'
    res.headers["Content-Type"].should == "text/html"
  end

  it "should respond to 404" do
    @browser.get '/nothing-is-at-this-url'
    res.status.should == 404
    body.should have_selector("h2", :content => "404 (Not Found)")
  end

  describe "Default layout specs" do

    it "should display the correct title" do
      @browser.get "/"
      body.should have_selector("title", :content => "#{BLOG_DESCRIPTION} | #{BLOG_TITLE}")
    end

    it "should have an archive link" do
      @browser.get "/"
      body.should have_selector("a#archives")
    end

    it "should have an RSS feed link" do
      @browser.get "/"
      body.should have_selector("a#feed")
    end

  end

end
