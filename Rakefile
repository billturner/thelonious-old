require 'rubygems'
require 'dm-core'
require 'sinatra' unless defined?(Sinatra)
 
namespace :db do

  require 'config/database'
 
  desc "Migrate the database"
  task :migrate => :environment do
    DataMapper.auto_migrate!
  end

  desc "Upgrade the database"
  task :upgrade => :environment do
    DataMapper.auto_upgrade!
  end

  task :environment do
    ENV['RACK_ENV'] || :development
  end
  
end
