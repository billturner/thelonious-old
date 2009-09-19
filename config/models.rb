class Post
  include DataMapper::Resource
  property :id,         Serial
  property :title,      String,   :length => 255
  property :slug,       String,   :length => 255
  property :body,       Text
  property :created_at, DateTime
  property :updated_at, DateTime
  
end

# automatically create or upgrade the post table
Post.storage_exists? ? Post.auto_upgrade! : Post.auto_migrate!

# class User
#   include DataMapper::Resource
#   property :id,         Serial
#   property :login,      String
#   property :password,   Text
#   property :salt,       Text
#   property :created_at, DateTime
#   property :updated_at, DateTime
# end

# automatically create or upgrade the user table
# User.storage_exists? ? User.auto_upgrade! : User.auto_migrate!

class Page
  include DataMapper::Resource
  property :id,         Serial
  property :title,      String,   :length => 255
  property :slug,       String,   :length => 255
  property :body,       Text
  property :created_at, DateTime
  property :updated_at, DateTime
end

# automatically create or upgrade the page table
Page.storage_exists? ? Page.auto_upgrade! : Page.auto_migrate!
