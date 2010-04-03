require 'rubygems'
require 'sinatra' unless defined?(Sinatra)
require 'spec/rake/spectask'

namespace :app do

  desc "Copy .example files into place"
  task :setup do
    puts    "Moving settings file..."
    system  "cp config/settings.rb.sample config/settings.rb"
    puts    "Moving database file..."
    system  "cp lib/database.rb.sample lib/database.rb"
    puts    "Moving layout view file..."
    system  "cp views/layout.example views/layout.haml"
    puts    "Moving custom CSS file..."
    system  "cp public/stylesheets/sass/custom.example public/stylesheets/sass/custom.sass"
    puts    "Done."
  end

end

namespace :testing do

  desc "Swap default layout files into place BEFORE testing (and backing up originals)"
  task :templates_on do
    puts    "Backing up own layout"
    system  "cp views/layout.haml views/layout.mine"
    system  "cp public/stylesheets/sass/custom.sass public/stylesheets/sass/custom.mine"
    puts    "Copying default template into place"
    system  "cp views/layout.example views/layout.haml"
    system  "cp public/stylesheets/sass/custom.example public/stylesheets/sass/custom.sass"
  end

  desc "Swap personal layout files into place AFTER testing"
  task :templates_off do
    puts    "Copying personal templates back into place"
    system  "mv views/layout.mine views/layout.haml"
    system  "mv public/stylesheets/sass/custom.mine public/stylesheets/sass/custom.sass"
  end

end

Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
  spec.spec_opts = ["--options", "spec/spec.opts"]
  #spec.rcov = true
end

task :default => :spec
