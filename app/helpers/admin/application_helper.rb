require 'list_forms'

module Admin::ApplicationHelper
  include SharedHelper
  include MenuBuilderHelpers
  include FckEditorHelpers

  def action(*args)
    content_tag(:span, link_to(*args))
  end

  def actions(&block)
    concat(content_tag(:div, capture(&block), :class => "page_actions"), block.binding)
  end

  def zebra_row(&block)
    concat(content_tag(:tr, capture(&block), :class => cycle('light', 'dark')), block.binding)
  end

  def zebra_row_for(object, &block)
    content_tag_for(:tr, object, {:class => cycle('light', 'dark')}, &block)
  end

  def build_main_menu
    menu = [
      [:pages, "Pages", admin_pages_path]
    ]

    build_tiered_menu(menu)
  end

  def build_right_menu
    build_menu (
      [:users, 'Users', admin_users_path]
    )
  end

  def shared_paginator_for(name)
    render :partial => "admin/shared/paginator", :locals => { :paginator => instance_variable_get("@#{name}") }
  end
end
