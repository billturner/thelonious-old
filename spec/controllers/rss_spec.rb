require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "RSS Feed Tests" do

  it "should return the correct content-type when viewing the RSS feed" do
    get '/rss'
    last_response.headers["Content-Type"].should contain("application/rss+xml")
  end

  it "should not have any <item>s if there are no posts"

  it "should have the correct number of <item>s"

  it "should not display entries that haven't been published yet"

end
