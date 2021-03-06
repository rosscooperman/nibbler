module SharedHelper
  def flash_messages(*names)
    String.new.tap do |output|
      names.each do |name|
        if content = flash[name]
          output << content_tag(:p, content, :class => "flash #{name}", :id => "flash_#{name}")
          flash.discard(name)
        end
      end
    end.html_safe
  end

  def strip_ampersands(string)
    (string || "").gsub(/&amp;/xim, '&')
  end

  def body_tag(sidebar = false)
    body = "<body"
    body << " class=\"#{@body_id || controller.controller_name}"
    body << " aux" unless content_for(:sidebar).blank?
    body << "#{@body_class}" if @body_class
    body << "\">"
    body.html_safe
  end

  def app_url(path)
    "http://#{app_host}#{path}"
  end

  def app_host
    SETTINGS[:app_host]
  end

  def git_version_html
    GitRevision.revision_html
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

  def company_name
    "Nibbler"
  end

end
