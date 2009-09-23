class Post
  
  attr_accessor :taglist
  
  include DataMapper::Resource
  property :id,           Serial
  property :title,        String,   :length => 255
  property :slug,         String,   :length => 255
  property :body,         Text
  property :published,    Boolean,  :default => false
  property :published_at, DateTime
  property :created_at,   DateTime
  property :updated_at,   DateTime
  
  has n,  :taggings
  has n,  :tags,    :through => :taggings
  
  before  :save,    :determine_publish_status  
  after   :create,  :generate_slug
  after   :create,  :assign_tags
  after   :update,  :update_tags
  
  private
    
    class << self
      
      def recently_published
        self.all(:published => true, :order => [:published_at.desc], :limit => 15)
      end
      
    end
    
    def generate_slug
      self.update(:slug => "#{title.gsub(/[^a-z0-9]+/i, '-').gsub(/-$/, '').downcase}")
    end
    
    def determine_publish_status
      self.published_at = Time.now if published? && published_at.blank?
    end
    
    def assign_tags
      self.taglist.split(',').collect { |t| t.strip }.uniq.each do |tag|
        current_tag = Tag.first_or_create(:name => tag.downcase)
        self.tags << current_tag
      end
    end
  
    def update_tags
      self.taggings.each { |tagging| tagging.destroy }
      self.taggings.reload
      assign_tags
    end
    
end

class Tagging
  
  include DataMapper::Resource
  property :id,         Serial
  property :post_id,    Integer
  property :tag_id,     Integer
  
  belongs_to :post
  belongs_to :tag
  
end
 
class Tag
  
  include DataMapper::Resource
  property :id,         Serial
  property :name,       String,   :length => 50
  property :slug,       String,   :length => 50
  property :created_at, DateTime
  property :updated_at, DateTime
  
  has n, :taggings
  has n, :posts, :through => :taggings
    
  after :create, :generate_slug

  private
    
    class << self
      
      def published_posts
        self.posts(:published => true, :order => [:published_at.desc])
      end

    end
    
    def generate_slug
      self.update(:slug => "#{name.gsub(/[^a-z0-9]+/i, '-').gsub(/-$/, '').downcase}")
    end
    
end

class User
  
  include DataMapper::Resource
  property :id,         Serial
  property :login,      String
  property :password,   Text
  property :salt,       Text
  property :created_at, DateTime
  property :updated_at, DateTime

end

class Page

  include DataMapper::Resource
  property :id,         Serial
  property :title,      String,   :length => 255
  property :slug,       String,   :length => 255
  property :body,       Text
  property :created_at, DateTime
  property :updated_at, DateTime

  after :create, :generate_slug
  
  private
    
    def generate_slug
      self.update(:slug => "#{title.gsub(/[^a-z0-9]+/i, '-').gsub(/-$/, '').downcase}")
    end

end
