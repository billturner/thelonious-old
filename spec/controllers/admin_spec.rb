require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "Admin App Tests" do

  before(:each) do
    @browser = Rack::Test::Session.new(Rack::MockSession.new(app, test_domain))
  end
  
  it "should not see admin links for a regular visitor" do
    @browser.get '/'
    res.should be_ok
    body.should_not have_selector("a", :href => "/new_page", :content => "New Page")
    body.should_not have_selector("a", :href => "/all_pages", :content => "All Pages")
    body.should_not have_selector("a", :href => "/new_post", :content => "New Post")
    body.should_not have_selector("a", :href => "/all_posts", :content => "All Posts")
    body.should_not have_selector("a", :href => "/logout", :content => "Log out")
  end

  it "should be able to log in" do
    @browser.get '/login'
    body.should have_selector("input", :type => "text", :name => "login[username]")
    body.should have_selector("input", :type => "password", :name => "login[password]")
    login!
    @browser.follow_redirect!
    @browser.last_request.url.should == "#{BLOG_URL}/"
    res.should be_ok
  end

  it "should see admin links once logged in" do
    login!
    @browser.get '/'
    body.should have_selector("a", :href => "/new_page", :content => "New Page")
    body.should have_selector("a", :href => "/all_pages", :content => "All Pages")
    body.should have_selector("a", :href => "/new_post", :content => "New Post")
    body.should have_selector("a", :href => "/all_posts", :content => "All Posts")
    body.should have_selector("a", :href => "/logout", :content => "Log out")
  end

end
