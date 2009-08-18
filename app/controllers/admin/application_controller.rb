class Admin::ApplicationController < ActionController::Base
  include SharedControllerBehavior
  
  before_filter :login_required unless RAILS_ENV == 'test'
  before_filter :login_from_cookie

  filter_parameter_logging :password

  attr_accessor :current_tab
  
  layout "application"
  
  # def build_main_menu
  #   menu = []
  #   menu << {:tab => :foo,          :text => 'foo',           :url => "foo"}
  #   menu << {:tab => :foo,          :text => 'foo',           :url => "foo",
  #            :subtabs => [{:tab => :foo   :text => 'Foo',     :url => "foo"},
  #                         {:tab => :foo,  :text => 'Foo', :url => "foo"}]}
  # 
  #   build_tiered_menu(menu)
  # end
  # 
  # def build_tiered_menu(items)
  #   out = ""
  #   li_elements = []
  #   items.each do |item|
  #     li_elements << build_li_for(item)
  #   end
  #   out += content_tag(:ul, li_elements, :id => "gns_01")
  #   out
  # end
  # 
  # def build_li_for(item)
  #     li_class = @current_tab == item[:tab] ? "active" : ""
  #     li_content = link_to(item[:text], item[:url])
  #     if item.has_key? :subtabs
  #       subtab_li_elements = []
  #       item[:subtabs].each do |subtab_item|
  #         subtab_li_elements << build_li_for(subtab_item)
  #       end
  #       li_content += content_tag('ul', subtab_li_elements)
  #     end
  #     content_tag(:li, li_content, :class => li_class)
  # end
  # 
  # def section_links(section)
  #   section_links = ""
  #   section.links.each do |l|
  #     section_links += content_tag(:li, link_to(l.text, send(l.url), :class => l.class))
  #   end
  #   section_links
  # end
  # 
  # def build_right_menu
  #   build_menu(
  #     [:users, 'Users', admin_users_path]
  #   )
  # end
  #          
  # def build_menu(*items)
  #   items.map do |item|
  #     if !item[3] || current_user.send(item[3])
  #       %Q{<li#{ ' class="active"' if @current_tab == item[0] }>#{link_to(item[1], item[2])}</li>}
  #     end
  #   end.join
  # end
  

protected
  def ensure_is_admin
    unless current_user && current_user.admin?
      authorization_denied
    end
  end
end
