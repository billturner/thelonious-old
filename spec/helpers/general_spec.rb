require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'Helpers' do

  include Rack::Test::Methods
  
  before (:each) do
    # @post = Post.create(Factory.attributes_for(:post))
    # @tag = Tag.create(Factory.attributes_for(:tag, :name => 'testing'))
  end

  it "should generate a permalink url" do
    pending
  end

  it "should generate a tag url" do
    #tag_url(@tag).should == "#{BLOG_URL}/tag/testing"
    pending
  end

  it "should generate a page url" do
    pending
  end

  it "should convert text to markdown" do
    pending
  end

  it "should wrap the content in a CDATA tag" do
    pending
  end

end
