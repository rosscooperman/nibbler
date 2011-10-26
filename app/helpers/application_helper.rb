# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include SharedHelper
  
  def tab(text, url, li_attributes = {}, link_attributes = {})
    active = if @force_active_tab && @force_active_tab == text
      'active'
    elsif @force_active_subtab && @force_active_subtab == text
      'active'
    elsif @force_active_tab.nil?
      'active' if (url == "/" && request.path == "/") || (url != "/" && request.path.starts_with?(url))
    end

    if active && li_attributes[:class]
      li_attributes[:class] += " #{active}"
    elsif active
      li_attributes[:class] = active
    end

    content_tag(:li, link_to(text, url, link_attributes), li_attributes)
  end
  
  def home_link(text, url, li_attributes = {}, link_attributes = {})
    active = if @force_active_tab && @force_active_tab == text
      'active'
    elsif @force_active_subtab && @force_active_subtab == text
      'active'
    elsif @force_active_tab.nil?
      'active' if (url == "/" && request.path == "/") || (url != "/" && request.path.starts_with?(url))
    end

    if active && li_attributes[:class]
      li_attributes[:class] += " #{active}"
    elsif active
      li_attributes[:class] = active
    end

    content_tag(:p, link_to(text, url, link_attributes), li_attributes)
  end
  
  def errors_for(object, options = {})
    options = {
      :header => true
    }.merge(options)
    options[:object] = object
    
    render :partial => "layouts/errors", :object => options if object.errors.count > 0
  end
end
