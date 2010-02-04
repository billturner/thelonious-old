require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'Model - Post' do

  before(:each) do
    Post.delete_all
  end

  describe "Basic validations" do

    it 'should be valid' do
      post = Factory.build(:post)
      post.should be_valid
    end

    it 'should not be valid without a body' do
      post = Factory.build(:post, :body => nil)
      post.should_not be_valid
      post.errors[:body].should_not be_empty
      post.errors[:body].should include("can't be empty")
    end

    it 'should not be valid without a title' do
      post = Factory.build(:post, :title => nil)
      post.should_not be_valid
      post.errors[:title].should_not be_empty
      post.errors[:title].should include("can't be empty")
    end

    it 'should have a title' do
      post = Factory.build(:post)
      post.title.should == 'Test Post'
    end

    it 'should have a body' do
      post = Factory.build(:post)
      post.body.should == 'This is some test content!'
    end

  end

  describe "helper methods & tags" do

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
      post2.errors[:title].should_not be_empty
      post2.errors[:title].should include("has already been taken")
    end

    it "should allow tags" do
      post = Factory.build(:post)
      post.tags.length.should == 2
      post.tags.should include('code')
      post.tags.should include('web')
    end 

    it "should update the tags if they change after update" do
      post = Factory.build(:post)
      post.tags.length.should == 2
      post.tags.should include('code')
      post.tags.should include('web')
      post.update_attributes(:tags => 'code, personal, another')
      post.tags.length.should == 3
      post.tags.should include('code')
      post.tags.should include('personal')
      post.tags.should include('another')
    end

    it "should delete all tags if they were erased on an update" do
      post = Factory.build(:post)
      post.tags.length.should == 2
      post.tags.should include('code')
      post.tags.should include('web')
      post.update_attributes(:tags => '')
      post.tags.length.should == 0
      post.tags.should be_empty
    end

    it "should add tags if created with none, and added later" do
      post = Factory.build(:post, :tags => '')
      post.tags.should be_empty
      post.tags.length.should == 0
      post.update_attributes(:tags => 'code, web')
      post.tags.should_not be_empty
      post.tags.length.should == 2
      post.tags.should include('code')
      post.tags.should include('web')
    end

    it "should not allow the same tag twice" do
      post = Factory.build(:post, :tags => 'code, web, code')
      post.tags.should_not be_empty
      post.tags.length.should == 2
      post.tags.should include('code')
      post.tags.should include('web')
    end

    it "should fill in the published_at date when published? is true" do
      post = Post.create(Factory.attributes_for(:post, :published => false))
      post.published.should be_false
      post.published_at.should be_nil
      post.update_attributes(:published => true)
      post.published.should be_true
      post.published_at.should_not be_nil
    end

    it "should remove the published_at date if currently published, but no longer published?" do
      post = Post.create(Factory.attributes_for(:post))
      post.published.should be_true
      post.published_at.should_not be_nil
      post.update_attributes(:published => false)
      post.published.should be_false
      post.published_at.should be_nil
    end

  end

end
