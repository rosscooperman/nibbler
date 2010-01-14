namespace :static_templates do
  desc "Generate static templates"
  task :generate do
    require File.dirname(__FILE__) + "/../../config/environment"
    StaticPageGenerator.generate
  end
end
