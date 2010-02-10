require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "Pages Specs" do

  before(:each) do
    Page.delete_all
    @browser = Rack::Test::Session.new(Rack::MockSession.new(app, test_domain))
  end

  describe "Pages using the default template" do

    it "should not have any page links without anything created (default template)" do
      @browser.get "/"
      body.should_not have_selector("h4#pages-header")
    end

    it "should display correct number of pages" do
      Factory.create(:page)
      @browser.get "/"
      body.should have_selector("h4#pages-header")
      body.should have_selector("ul#pages > li", :count => 1)
      # create another page
      Factory.create(:page, :title => "Another Page", :body => "Here is some more page content. This one has some different text.")
      @browser.get "/"
      body.should have_selector("ul#pages > li", :count => 2)
    end

  end

end
