require File.dirname(__FILE__) + "/../helpers/list_forms"

class ApplicationController < ActionController::Base
  include SharedControllerBehavior
  include SharedHelper

  before_filter :login_from_cookie
  
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
end
