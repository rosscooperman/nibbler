require 'git_rev_num'

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
end
