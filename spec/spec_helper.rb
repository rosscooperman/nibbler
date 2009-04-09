# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'


require 'faker'
require File.expand_path(File.dirname(__FILE__) + "/rspec_extensions")
require File.dirname(__FILE__) + "/spec_helpers"

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  config.include FixtureReplacement
  config.include SpecHelpers
  config.include SpecHelpers::ControllerHelpers, :type => :controller

  %w[model].each do |matcher|
    require File.expand_path(File.dirname(__FILE__) + "/matchers/#{matcher}_matchers")
    config.include "#{matcher}_matchers".camelize.constantize
  end
end

