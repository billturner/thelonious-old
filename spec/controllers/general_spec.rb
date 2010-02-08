require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "General View / Controller Spec" do

  before(:each) do
    @browser = Rack::Test::Session.new(Rack::MockSession.new(app, test_domain))
  end

  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end

  it "should return the correct content-type when viewing root" do
    get '/'
    last_response.headers["Content-Type"].should == "text/html"
  end

  it "should respond to 404" do
    get '/nothing-is-at-this-url'
    last_response.status.should == 404
    last_response.should have_selector("h2", :content => "404 (Not Found)")
  end

end
