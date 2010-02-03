require 'rubygems'
require 'sinatra' unless defined?(Sinatra)
require 'spec/rake/spectask'

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

Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
  spec.spec_opts = ["--options", "spec/spec.opts"]
  #spec.rcov = true
end

task :default => :spec
