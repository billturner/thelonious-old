require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "Posts Specs" do

  before(:each) do
    Post.delete_all
    @browser = Rack::Test::Session.new(Rack::MockSession.new(app, test_domain))
  end

  it "should not have any posts without anything created" do
    @browser.get "/"
    body.should_not have_selector("div.post")
  end

  it "should display correct number of posts" do
    Factory.create(:post)
    @browser.get "/"
    body.should have_selector("div.post", :count => 1)
    # create another post
    Factory.create(:post, :title => "This is another post", :body => "Some more bogus copy")
    @browser.get "/"
    body.should have_selector("div.post", :count => 2)
    # create another post, but leave unpublished
    Factory.create(:post, :title => "This post is unpublished", :body => "Body to be filled in later", :published => false)
    @browser.get "/"
    body.should have_selector("div.post", :count => 2)
  end

end
