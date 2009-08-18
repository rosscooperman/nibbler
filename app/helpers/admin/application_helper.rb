require 'list_forms'

module Admin::ApplicationHelper
  include SharedHelper
  
  def action(*args)
    content_tag(:span, link_to(*args))
  end
  
  def actions(&block)
    concat(content_tag(:div, capture(&block), :class => "page_actions"), block.binding)
  end
  
  def dataset(data, partial_name = nil, options = {})
    partial_options = partial_name ? {:partial => partial_name, :collection => data} : {:partial => data}
    content_tag(:table, render(partial_options.merge(options)), :class => "dataset" )
  end
  
  def dataset_if_any(data, partial_name = nil, options = {}, &block)
    data.any? ? concat(dataset(data, partial_name, options), block.binding) : yield
  end

  def sortable_dataset(data, partial_name = nil, options = {})
    partial_options = partial_name ? {:partial => partial_name, :collection => data} : {:partial => data}
    content_tag(:ul, render(partial_options.merge(options)), :class => "sortable_dataset", :id => options[:id] ? options[:id] : nil )
  end
  
  def sortable_dataset_if_any(data, partial_name = nil, options = {}, &block)
    data.any? ? concat(sortable_dataset(data, partial_name, options), block.binding) : yield
  end
  def zebra_row(&block)
    concat(content_tag(:tr, capture(&block), :class => cycle('light', 'dark')), block.binding)
  end
  
  def zebra_row_for(object, &block)
    content_tag_for(:tr, object, {:class => cycle('light', 'dark')}, &block)
  end
  
  def sortable_zebra_row(object, options = {}, &block)
    content_tag(:li, {:class => cycle('light', 'dark'), :id => options[:id]}, &block)
  end

  def up_button_for(playlist_position)
    return if playlist_position.first?
    link_to "Up", up_admin_playlist_path(:id => playlist_position.playlist_id, :video_id => playlist_position.video_id), :method => :put
  end
  
  def down_button_for(playlist_position)
    return if playlist_position.last?
    link_to "Down", down_admin_playlist_path(:id => playlist_position.playlist_id, :video_id => playlist_position.video_id), :method => :put
  end

  def object_updated_at
    "<span>(Updated #{format_updated_at(:updated_at)})</span>"
  end
  
  def format_updated_at(attribute, object = nil)
    object ||= current_object
    attribute = object.send(attribute)
    return '' if attribute.blank?
    
    date = if Time.now.beginning_of_day < attribute
      "Today"
    elsif (Time.now.beginning_of_day - 1.day) < attribute
      "Yesterday"
    else
      attribute.strftime('%a %D')
    end
  end
  
  def build_main_menu
    menu = []
    menu << {:tab => :pages,          :text => 'Pages',         :url => admin_pages_path}
    menu << {:tab => :pages,          :text => 'Pages',         :url => admin_pages_path,
             :subtabs => [{:tab => :pages,          :text => 'Pages',         :url => admin_pages_path},
                          {:tab => :pages,          :text => 'Pages',         :url => admin_pages_path}]}

    build_tiered_menu(menu)
  end
  
  def build_tiered_menu(items)
    out = ""
    li_elements = []
    items.each do |item|
      li_elements << build_li_for(item)
    end
    out += content_tag(:ul, li_elements, :id => "gns_01")
    out
  end
  
  def build_li_for(item)
      li_class = @current_tab == item[:tab] ? "active" : ""
      li_content = link_to(item[:text], item[:url])
      if item.has_key? :subtabs
        subtab_li_elements = []
        item[:subtabs].each do |subtab_item|
          subtab_li_elements << build_li_for(subtab_item)
        end
        li_content += content_tag('ul', subtab_li_elements)
      end
      content_tag(:li, li_content, :class => li_class)
  end
  
  def section_links(section)
    section_links = ""
    section.links.each do |l|
      section_links += content_tag(:li, link_to(l.text, send(l.url), :class => l.class))
    end
    section_links
  end
  
  def build_right_menu
    build_menu(
      [:users, 'Users', admin_users_path]
    )
  end
  
  def help_content(&block)
    content_for :sidebar, &block
  end
  
  def build_menu(*items)
    items.map do |item|
      if !item[3] || current_user.send(item[3])
        %Q{<li#{ ' class="active"' if @current_tab == item[0] }>#{link_to(item[1], item[2])}</li>}
      end
    end.join
  end

  def sort_link_for(title, sort)
    current_url = request.url
    url_hash = ActionController::Routing::Routes.recognize_path(request.path) rescue {}
    url_hash = url_hash.merge(request.query_parameters.symbolize_keys)
    url_hash = url_hash.merge(:sort => sort)
    content_tag(:li, link_to(title, url_for(url_hash)), :class => (params[:sort].to_s == sort.to_s ? "active" : "inactive"))
  end

  def tab(text, url, id = nil)
    if @force_active_tab && @force_active_tab == text
      active_css_class  = 'active'
    elsif @force_active_tab.nil?
      active_css_class  = 'active' if (url == "/" && request.path == "/") || (url != "/" && request.path.starts_with?(url))
    end
    content_tag(:li, link_to(content_tag(:span, text), url, :class => "tab"), :class => "tab #{active_css_class}", :id => id)
  end

  def shared_paginator_for(name, &block)
    paginator = render :partial => "admin/shared/paginator", :locals => { :paginator => instance_variable_get("@#{name}") }
    
    concat(paginator, block.binding)
    concat(capture(&block), block.binding)
    concat(paginator, block.binding)
  end

  def sluggable_form_for(name, options={ }, &blk)
    var = instance_variable_get("@#{name}")
    html_method = var.new_record? ? :post : :put

    options[:html] ||= { }
    options[:html][:method] = html_method

    url_method = controller.class.to_s.include?("Admin::") ? "admin_#{name}_path" : "#{name}_path"
    options[:url] = self.__send__(url_method, var.slug)
    
    form_for(name, var, options, &blk)
  end
end
