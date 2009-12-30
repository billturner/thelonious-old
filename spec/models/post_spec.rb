require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'Model - Post' do
  
  before(:each) do

  end

  it 'should be valid' do
    post = Factory.build(:post)
    post.should be_valid
  end

  it 'should not be valid without a body' do
    post = Factory.build(:post, :body => nil)
    post.should_not be_valid
    post.errors[:body].should include("Body must not be blank")
  end

  it 'should not be valid without a title' do
    post = Factory.build(:post, :title => nil)
    post.should_not be_valid
    post.errors[:title].should include("Title must not be blank")
  end

  it 'should have a title' do
    post = Factory.build(:post)
    post.title.should == 'Test Post'
  end

  it 'should have a body' do
    post = Factory.build(:post)
    post.body.should == 'This is some test content!'
  end

  it "should generate a slug" do
    post = Post.create(Factory.attributes_for(:post))
    post.slug.should_not be_empty
  end

  it "should not generate a slug with a dash at the end" do
    post = Post.create(Factory.attributes_for(:post, :title => "This is a test?"))
    post.slug.should_not == 'this-is-a-test-'
    post.slug.should == 'this-is-a-test'
  end

  after(:each) do
    Post.all.destroy!
  end

end
