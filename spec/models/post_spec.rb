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

  it "should not allow the same title/slug" do
    post1 = Post.create(Factory.attributes_for(:post))
    post2 = Post.create(Factory.attributes_for(:post))
    post2.should_not be_valid
    post2.errors[:title].should include("Title is already taken")
  end

  it "should allow tags" do
    post = Factory.build(:post, :taglist => nil)
    tag1 = Factory.build(:tag, :name => 'code')
    tag2 = Factory.build(:tag, :name => 'web')
    post.tags << tag1
    post.tags << tag2
    post.tags.length.should == 2
    tag_names = post.tags.collect{ |t| t.name }
    tag_names.should include('code')
    tag_names.should include('web')
  end 

  it "should allow tags (with taglist attribute)" do
    post = Post.create(Factory.attributes_for(:post))
    post.tags.length.should == 2
    tag_names = post.tags.collect{ |t| t.name }
    tag_names.should include('code')
    tag_names.should include('web')
  end 

  it "should not allow the same tag twice" do
    pending("not sure how to do this without a unique on has n :through associations")
  end

  it "should update the tags if they change after update (with taglist attribute)" do
    post = Post.create(Factory.attributes_for(:post))
    post.tags.length.should == 2
    tag_names = post.tags.collect{ |t| t.name }
    tag_names.should include('code')
    tag_names.should include('web')
    post.update(:taglist => 'code, personal')
    post.tags.reload
    post.tags.length.should == 2
    tag_names = post.tags.collect{ |t| t.name }
    tag_names.should include('code')
    tag_names.should include('personal')
  end

  it "should delete all tags if they were erased on an update" do
    post = Post.create(Factory.attributes_for(:post))
    post.tags.length.should == 2
    tag_names = post.tags.collect{ |t| t.name }
    tag_names.should include('code')
    tag_names.should include('web')
    post.update(:taglist => nil)
    post.tags.reload
    post.tags.length.should == 0
  end

  it "should fill in the published_at date when published? is true" do
    post = Post.create(Factory.attributes_for(:post, :published => false))
    post.published.should be_false
    post.published_at.should be_nil
    post.update(:published => true)
    post.published.should be_true
    post.published_at.should_not be_nil
  end

  it "should remove the published_at date if currently published, but no longer published?" do
    post = Post.create(Factory.attributes_for(:post))
    post.published.should be_true
    post.published_at.should_not be_nil
    post.update(:published => false)
    post.published.should be_false
    post.published_at.should be_nil
  end

  after(:each) do
    Post.all.destroy!
  end

end
