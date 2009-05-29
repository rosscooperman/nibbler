unless defined?(SETTINGS) || RAILS_ENV == "test"
  settings_yml = File.join(RAILS_ROOT, 'config', 'settings.yml')
  unless File.exists?(settings_yml)
    raise RuntimeError, "Unable to find \"config/settings.yml\" file."
  end

  SETTINGS = YAML.load_file(settings_yml).recursively_symbolize_keys[RAILS_ENV.to_sym]

  unless SETTINGS.key?(:app_host)
    raise RuntimeError, "SETTINGS requires :app_host key"
  end

  ActionMailer::Base.default_url_options[:host] = SETTINGS[:app_host]

  # Enable serving of images, stylesheets, and javascripts from an asset server
  if SETTINGS.key?(:asset_host)
    ActionController::Base.asset_host = SETTINGS[:asset_host]
  end

  # Set Image Science INLINEDIR environment variable. Only really necessary for EngineYard.
  if SETTINGS.key?(:image_science_inlinedir)
    ENV['INLINEDIR'] = SETTINGS[:image_science_inlinedir]
  end
end
