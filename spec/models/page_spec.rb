require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'Model - Page' do
  
  before(:each) do
    Page.delete_all
  end

  it 'should be valid' do
    page = Factory.build(:page)
    page.should be_valid
  end

  it 'should not be valid without a body' do
    page = Factory.build(:page, :body => nil)
    page.should_not be_valid
    page.errors[:body].should_not be_empty
    page.errors[:body].should include("can't be empty")
  end

  it 'should not be valid without a title' do
    page = Factory.build(:page, :title => nil)
    page.should_not be_valid
    page.errors[:title].should_not be_empty
    page.errors[:title].should include("can't be empty")
  end

  it 'should have a title' do
    page = Factory.build(:page)
    page.title.should == "About"
  end

  it 'should have a body' do
    page = Factory.build(:page)
    page.body.should == "This is my about page.\n\nHere is some about content."
  end

  it "should generate a slug" do
    page = Page.create(Factory.attributes_for(:page))
    page.slug.should_not be_empty
  end

  it "should not generate a slug with a dash at the end" do
    page = Page.create(Factory.attributes_for(:page, :title => "This is a test?"))
    page.slug.should_not == 'this-is-a-test-'
    page.slug.should == 'this-is-a-test'
  end

  it "should not allow the same title/slug" do
    page = Page.create(Factory.attributes_for(:page))
    page2 = Page.create(Factory.attributes_for(:page))
    page2.should_not be_valid
    page2.errors[:title].should_not be_empty
    page2.errors[:title].should include("has already been taken")
  end

end
