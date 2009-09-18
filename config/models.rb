class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :body, Text
  property :created_at, DateTime
end

# automatically create the post table
DataMapper.repository.storage_exists?(Post) ? Post.auto_upgrade! : Post.auto_migrate!
