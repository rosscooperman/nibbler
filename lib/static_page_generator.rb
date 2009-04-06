class StaticPageGenerator
  def self.generate
    new.generate
  end

  def generate
    templates.each do |template_name|
      auth = if SETTINGS.key?(:http_basic_auth) && SETTINGS[:http_basic_auth].key?(:user) && SETTINGS[:http_basic_auth].key?(:password)
        " -u #{SETTINGS[:http_basic_auth][:user]}:#{SETTINGS[:http_basic_auth][:password]} "
      else
        ""
      end
      sh "curl #{auth} http://#{SETTINGS[:app_host]}/static/#{template_name} > #{RAILS_ROOT}/public/#{template_name}.html"
    end
  end

  def templates
    @templates ||= Dir.glob("#{RAILS_ROOT}/app/views/static/*").map do |file|
      File.basename(file).gsub(".html.erb", "")
    end
  end
end
