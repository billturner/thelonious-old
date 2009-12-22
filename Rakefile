require 'rubygems'
require 'dm-core'
require 'sinatra' unless defined?(Sinatra)

namespace :app do
  
  desc "Move .example files into place"
  task :setup_files do
    puts    "Moving settings file..."
    system  "mv config/settings.rb.sample config/settings.rb"
    puts    "Moving layout view file..."
    system  "mv views/layout.example views/layout.haml"
    puts    "Moving custom CSS file..."
    system  "mv views/stylesheets/custom.example views/stylesheets/custom.sass"
    puts    "Done."
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
