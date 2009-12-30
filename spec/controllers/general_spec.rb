require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "General App Tests" do

  include Rack::Test::Methods

  def app
    @app ||= SinatraBlog
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
  end
  
end
