require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'Model - Tag' do
  
  before(:each) do

  end

  it 'should be valid' do
    tag = Factory.build(:tag)
    tag.should be_valid
  end

  it 'should not be valid without a name' do
    tag = Factory.build(:tag, :name => nil)
    tag.should_not be_valid
    tag.errors[:name].should include("Name must not be blank")
  end
  
  it "should not allow two with the same name" do
    tag1 = Tag.create(Factory.attributes_for(:tag))
    tag2 = Tag.create(Factory.attributes_for(:tag))
    tag2.should_not be_valid
    tag2.errors[:name].should include("Name is already taken")
  end

  it "should generate a slug" do
    tag = Tag.create(Factory.attributes_for(:tag))
    tag.slug.should_not be_empty
  end
  
  it "should not generate a slug with a dash at the end" do
    tag = Tag.create(Factory.attributes_for(:tag, :name => "odd one?"))
    tag.slug.should_not == 'odd-one-'
    tag.slug.should == 'odd-one'
  end

  after(:each) do
    Tag.all.destroy!
  end

end
