%w[rubygems rake rake/clean fileutils newgem rubigen].each { |f| require f }
require File.dirname(__FILE__) + '/lib/hrmparser'

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
# $hoe = Hoe.new('teich-hrmparser', HRMParser::VERSION::STRING) do |p|
#   p.developer('Oren Teich', 'oren@teich.net')
#   p.changes              = p.paragraphs_of("History.txt", 0..1).join("\n\n")
#   p.rubyforge_name       = p.name # TODO this is default value
#   # p.extra_deps         = [
#   #   ['activesupport','>= 2.0.2'],
#   # ]
#   p.extra_dev_deps = [
#     ['newgem', ">= #{::Newgem::VERSION}"]
#   ]
#   
#   p.clean_globs |= %w[**/.DS_Store tmp *.log]
#   path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
#   p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/,''), 'rdoc')
#   p.rsync_args = '-av --delete --ignore-errors'
# end
# 
# require 'newgem/tasks' # load /tasks/*.rake
# Dir['tasks/**/*.rake'].each { |t| load t }
# 
# # TODO - want other tests/tasks run by default? Add them to the list
# task :default => [:spec, :features]
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "hrmparser"
    gemspec.summary = "Heart Rate Monitor Parser"
    gemspec.email = "oren@teich.net"
    gemspec.homepage = "http://github.com/teich/hrmparser"
    gemspec.description = "Parses Polar and Garmin HRM files."
    gemspec.authors = ["Oren Teich"]
    
    gemspec.files.exclude 'spec/samples/**/*'
    gemspec.test_files.exclude 'spec/samples/**/*'
    
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
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
end

task :default => :spec
