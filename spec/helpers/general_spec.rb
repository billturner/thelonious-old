require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'Helpers' do

  before (:each) do
    Post.delete_all
    Page.delete_all
  end

  it "should generate a permalink url" do
    post = Factory.create(:post, :title => "Permalink Test", :published_at => Time.utc(2010,2,10,12,30))
    permalink_url(post).should eql("#{BLOG_URL}/2010/02/permalink-test")
  end

  it "should generate a tag url" do
    tag = 'web'
    tag_url(tag).should eql("#{BLOG_URL}/tag/web")
    tag2 = 'ruby on rails'
    tag_url(tag2).should eql("#{BLOG_URL}/tag/ruby+on+rails")
  end

  it "should generate a page url" do
    page = Factory.create(:page, :title => "Page Permalink Test")
    page_url(page).should eql("#{BLOG_URL}/page/page-permalink-test")
  end

  it "should wrap the content in a CDATA tag" do
    string = "This is some text"
    cdata(string).should eql("<![CDATA[This is some text]]>")
  end

  it "should wrap the escaped content in a CDATA tag" do
    string = "This \"is\" some <span>text</span>"
    cdata_and_escape(string).should eql("<![CDATA[This &quot;is&quot; some &lt;span&gt;text&lt;/span&gt;]]>")
  end

  it "should convert text to markdown" do
    string = "This is a paragraph\n\nAnd this is another paragraph with it's fancy \"quote\"\n\n"
    markdown(string).should eql("<p>This is a paragraph</p>\n\n<p>And this is another paragraph with it&rsquo;s fancy &ldquo;quote&rdquo;</p>\n")
    link = "[Google](http://google.com/)"
    markdown(link).should eql("<p><a href=\"http://google.com/\">Google</a></p>\n")
  end

end
