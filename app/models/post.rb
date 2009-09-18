class Post
    include DataMapper::Resource
    property :id, Serial
    property :title, String
    property :body, Text
    property :created_at, DateTime
end

# automatically create the post table
Post.auto_migrate! unless Post.table_exists?