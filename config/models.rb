class Post
  
  include DataMapper::Resource
  property :id,         Serial
  property :title,      String,   :length => 255
  property :slug,       String,   :length => 255
  property :body,       Text
  property :created_at, DateTime
  property :updated_at, DateTime
  
  has n, :taggings
  has n, :tags, :through => :taggings
    
  after :create, :generate_slug

  private
    
    def generate_slug
      self.update(:slug => "#{title.gsub(/[^a-z0-9]+/i, '-').gsub(/-$/, '').downcase}")
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
  property :title,      String,   :length => 50
  property :slug,       String,   :length => 50
  property :created_at, DateTime
  property :updated_at, DateTime
  
  has n, :taggings
  has n, :posts, :through => :taggings
    
  after :create, :generate_slug

  private
    
    def generate_slug
      self.update(:slug => "#{title.gsub(/[^a-z0-9]+/i, '-').gsub(/-$/, '').downcase}")
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
