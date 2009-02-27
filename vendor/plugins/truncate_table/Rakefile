require 'rake'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'
require 'rake/rdoctask'

desc 'Default: run specs.'
task :default => :spec

desc 'Run the specs'
Spec::Rake::SpecTask.new do |t|
  t.warning = false
  t.spec_opts = ["--color"]
end

desc 'Generate documentation for the truncate_table plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'TruncateTable'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
