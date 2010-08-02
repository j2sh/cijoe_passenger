require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "cijoe_passenger"
    gem.summary = %Q{Makes CIJoe awesomer.}
    gem.description = %Q{Generates a CIJoe passenger instance with projects that automatically build.}
    gem.email = "gotascii@gmail.com"
    gem.homepage = "http://github.com/vigetlabs/cijoe_passenger"
    gem.authors = ["Justin Marney", "Tony Pitale"]
    gem.add_development_dependency "rspec", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
  spec.rcov_opts = ['--exclude', 'lib\/spec,bin\/spec,config\/boot.rb,gems,spec_helper']
end

task :rcovo => [:rcov] do
  system "open coverage/index.html"
end

task :test => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "cijoe_passenger #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
