module SharedHelper
  def flash_messages(*names)
    output = ""
    names.each do |name|
      if content = flash[name]
        output << content_tag(:p, content, :class => "flash #{name}", :id => "flash_#{name}")
        # output << javascript_tag(visual_effect(:fade, "flash_#{name}", :duration => 30))
        flash.discard(name)
      end
    end
    output
  end

  def strip_ampersands(string)
    (string || "").gsub(/&amp;/xim, '&')
  end
  
  def body_tag
    body = "<body"
    body << " id=\"#{@body_id || controller.controller_name}\""
    body << " class=\"#{@body_class}\"" if @body_class
    body << ">"
  end

  def app_url(path)
    "http://#{app_host}#{path}"
  end

  def app_host
    SETTINGS[:app_host]
  end

  def git_version_html
    @git_version_html ||= "<!-- git master:#{git_version} -->"
  end

  def git_version
    Grit::Repo.new(RAILS_ROOT).commits.first.id
  end

  def staging?
    SETTINGS[:staging]
  end
  
  def admin?
    controller.controller_path.include? "admin/"
  end
  
  def public?
    !admin?
  end
end
