require File.join(File.dirname(__FILE__), 'spec_helper')

describe "SinatraBlog" do
  include Rack::Test::Methods

  def app
    @app ||= SinatraBlog
  end

  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end
  
end
