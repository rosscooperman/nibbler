require File.dirname(__FILE__) + "/../../config/environment"

namespace :static_templates do
  desc "Generate static templates"
  task :generate do
    StaticPageGenerator.generate
  end
end
