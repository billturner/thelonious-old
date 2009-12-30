require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'Model - Page' do
  
  before(:each) do

  end

  it 'should be valid' do
    page = Factory.build(:page)
    page.should be_valid
  end

  it 'should not be valid without a body' do
    page = Factory.build(:page, :body => nil)
    page.should_not be_valid
    page.errors[:body].should include("Body must not be blank")
  end

  it 'should not be valid without a title' do
    page = Factory.build(:page, :title => nil)
    page.should_not be_valid
    page.errors[:title].should include("Title must not be blank")
  end

  it 'should have a title' do
    page = Factory.build(:page)
    page.title.should == 'This is a sample page'
  end

  it 'should have a body' do
    page = Factory.build(:page)
    page.body.should == 'This is some page content'
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
    pending
  end

  after(:each) do
    Page.all.destroy!
  end

end
