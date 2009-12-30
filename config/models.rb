require 'dm-validations'

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
  
  validates_present   :title
  validates_is_unique :title
  validates_present   :body
  
  has n,  :taggings
  has n,  :tags,    :through => :taggings
  
  before  :save,    :update_published_status
  before  :save,    :generate_slug
  after   :create,  :assign_tags
  after   :update,  :update_tags
  
  private
    
    class << self
      
      def recently_published
        self.all(:published => true, :order => [:published_at.desc], :limit => 15)
      end
      
      def all_published
        self.all(:published => true, :order => [:published_at.desc])
      end
      
      def all_drafts
        self.all(:published => false, :order => [:created_at.desc])
      end
      
    end
    
    def generate_slug
      self.slug = "#{self.title.gsub(/[^a-z0-9]+/i, '-').gsub(/-$/, '').downcase}" if !self.title.blank? && self.slug.blank?
    end
    
    def update_published_status
      self.published_at = Time.now if published? && published_at.blank?
      self.published_at = nil if !published? && !published_at.blank?
    end
    
    def assign_tags
      unless self.taglist.blank?
        self.taglist.split(',').collect { |t| t.strip }.uniq.each do |tag|
          current_tag = Tag.first_or_create(:name => tag.downcase)
          #self.tags << current_tag
          Tagging.create(:post_id => self.id, :tag_id => current_tag.id)
        end
      end
    end
  
    def update_tags
      self.taggings.each { |tagging| tagging.destroy }
      self.taggings.reload
      assign_tags unless self.taglist.blank?
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
  
  validates_present   :name
  validates_is_unique :name
  
  has n, :taggings
  has n, :posts, :through => :taggings
    
  before :save, :generate_slug

  private
    
    class << self
      
      def published_posts
        self.posts(:published => true, :order => [:published_at.desc])
      end

    end
    
    def generate_slug
      self.slug = "#{self.name.gsub(/[^a-z0-9]+/i, '-').gsub(/-$/, '').downcase}" if !self.name.blank? && self.slug.blank?
    end
    
end

class Page

  include DataMapper::Resource
  property :id,         Serial
  property :title,      String,   :length => 255
  property :slug,       String,   :length => 255
  property :body,       Text
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_present   :title
  validates_is_unique :title
  validates_present   :body

  before :save, :generate_slug

  private

    def generate_slug
      self.slug = "#{self.title.gsub(/[^a-z0-9]+/i, '-').gsub(/-$/, '').downcase}" if !self.title.blank? && self.slug.blank?
    end

end
