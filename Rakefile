require 'rubygems'
require 'dm-core'
require 'sinatra' unless defined?(Sinatra)

namespace :app do
  
  desc "Move .example files into place"
  task :setup_files do
    puts  "Moving database file..."
    run   "mv db/database.rb.sample db/database.rb"
    puts  "Moving settings file..."
    run   "mv db/settings.rb.sample db/settings.rb"
    puts  "Moving layout view file..."
    run   "mv views/layout.example views/layout.haml"
    puts  "Moving custom CSS file..."
    run   "mv views/stylesheets/custom.example views/stylesheets/custom.sass"
  end
  
end

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
