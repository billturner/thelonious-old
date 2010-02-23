class Post
  include MongoMapper::Document

  key :title,         String
  key :slug,          String,   :index => true
  key :body,          String
  key :published,     Boolean,  :default => false
  key :published_at,  Time
  key :tags,          Array,    :index => true
  timestamps!

  ensure_index "post.tags"
  ensure_index "post.slug"

  validates_presence_of   :title, :body
  validates_uniqueness_of :title

  before_save :update_published_status
  before_save :generate_slug

  def tags=(t)
    if t.kind_of?(String)
      t = t.split(",").collect{ |tag| tag.strip.downcase }.uniq
    end
    if t.kind_of?(Array)
      t = t.collect{ |tag| tag.strip.downcase }.uniq
    end
    self[:tags] = t
  end

  private

    class << self

      # TODO: perhap find another way to execute code
      # like this: http://www.gitorious.org/shapado/shapado/blobs/master/config/initializers/mongo.rb
      def all_tags(conditions = {})
        @all_tags ||= Thelonious.lib + "/tag_list.js"
        self.database.eval(File.read(@all_tags), conditions)
      end

      def recently_published
        self.all(:published => true, :order => "published_at DESC", :limit => 15)
      end

      def all_published
        self.all(:published => true, :order => "published_at DESC")
      end

      def all_drafts
        self.all(:published => false, :order => "created_at DESC")
      end

    end

    def generate_slug
      self.slug = "#{self.title.gsub(/[^a-z0-9]+/i, '-').gsub(/-$/, '').downcase}" if !self.title.blank? && self.slug.blank?
    end

    def update_published_status
      self.published_at = Time.now if published? && published_at.blank?
      self.published_at = nil if !published? && !published_at.blank?
    end

end

class Page
  include MongoMapper::Document

  key :title, String
  key :slug,  String
  key :body,  String
  timestamps!

  validates_presence_of   :title, :body
  validates_uniqueness_of :title

  before_save :generate_slug

  private

    def generate_slug
      self.slug = "#{self.title.gsub(/[^a-z0-9]+/i, '-').gsub(/-$/, '').downcase}" if !self.title.blank? && self.slug.blank?
    end

end
