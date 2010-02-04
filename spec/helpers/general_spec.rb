require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'Helpers' do

  include Rack::Test::Methods
  #include SinatraBlog::Helpers

  before (:each) do
    Post.delete_all
    Page.delete_all
  end

  it "should generate a permalink url" do
    # post = Factory.create(:post, :title => "Permalink Test", :published_at => Time.utc(2010,2,10,12,30))
    # SinatraBlog::Helpers.permalink_url(post).should eql("#{BLOG_URL}/2010/02/permalink-test")
  end

  it "should generate a tag url"

  it "should generate a page url"

  it "should convert text to markdown"

  it "should wrap the content in a CDATA tag"

end
