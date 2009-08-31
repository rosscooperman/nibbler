# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/fixtures/settings")
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'
require 'faker'
require 'factory_girl'
require 'mocha'

require File.expand_path(File.dirname(__FILE__) + "/rspec_extensions")
require File.dirname(__FILE__) + "/spec_helpers"

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  config.mock_with :mocha

  config.include FixtureReplacement
  config.include SpecHelpers
  config.include SpecHelpers::ControllerHelpers, :type => :controller

  Dir.glob(File.join(File.dirname(__FILE__), "matchers", "*_matchers.rb")).each do |matcher|
    require matcher
    config.include File.basename(matcher, ".rb").camelize.constantize
  end
end
