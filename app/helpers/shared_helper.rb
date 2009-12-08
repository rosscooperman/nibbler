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

  def tab(text, url, id = nil)
    if @force_active_tab && @force_active_tab == text
      active_css_class  = 'active'
    elsif @force_active_tab.nil?
      active_css_class  = 'active' if (url == "/" && request.path == "/") || (url != "/" && request.path.starts_with?(url))
    end
    content_tag(:li, link_to(content_tag(:span, text), url, :class => "tab"), :class => "tab #{active_css_class}", :id => id)
  end

  def tab_link(text, url, id = nil)
    if @force_active_tab && @force_active_tab == text
      active_css_class  = 'active'
    elsif @force_second_active_tab && @force_second_active_tab == text
      active_css_class  = 'active'
    elsif @force_active_tab.nil? && @force_second_active_tab.nil?
      active_css_class  = 'active' if (url == "/" && request.path == "/") || (url != "/" && request.path.starts_with?(url))
    end
    link_to(content_tag(:span, text), url, :class => "#{active_css_class}", :id => id)
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
end
