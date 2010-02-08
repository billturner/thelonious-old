require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "Sitemap Specs" do

  before(:each) do
    Post.delete_all
    Page.delete_all
    @browser = Rack::Test::Session.new(Rack::MockSession.new(app, test_domain))
  end

  it "should respond to a basic request" do
    @browser.get "/sitemap.xml"
    res.should be_ok
  end

  it "should contain at least the root site URL, even without posts" do
    @browser.get "/sitemap.xml"
    res.should be_ok
    body.should have_selector("urlset > url > loc", :content => "#{BLOG_URL}/")
  end

end
