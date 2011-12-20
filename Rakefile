# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Nibbler::Application.load_tasks

annotate_gem = Gem.searcher.find('annotate')
Dir["#{annotate_gem.full_gem_path}/**/tasks/**/*.rake"].each {|ext| load ext} unless annotate_gem.nil?
