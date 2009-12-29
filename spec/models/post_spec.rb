require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'Model - Post' do
  
  before(:each) do
    @post = Post.new(:title => 'Test Post', :body => "This is some test content!")
  end
 
  specify 'should be valid' do
    @post.should be_valid
  end
  
  specify 'should not be valid without a body' do
    post = Post.new(:title => 'Test Post')
    post.should_not be_valid
    post.errors[:body].should include("Body must not be blank")
  end

  specify 'should not be valid without a title' do
    post = Post.new(:body => "This is some test content!")
    post.should_not be_valid
    post.errors[:title].should include("Title must not be blank")
  end

  it 'should have a title' do
    @post.title.should == 'Test Post'
  end

  it 'should have a body' do
    @post.body.should == 'This is some test content!'
  end

end
