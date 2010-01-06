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

  include MenuBuilderHelpers

  def build_main_menu
    menu = [
      [:pages, "Pages", admin_pages_path]
    ]

    build_tiered_menu(menu)
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

  def shared_paginator_for(name, &block)
    paginator = render :partial => "admin/shared/paginator", :locals => { :paginator => instance_variable_get("@#{name}") }

    concat(paginator, block.binding)
    concat(capture(&block), block.binding)
    concat(paginator, block.binding)
  end
end
