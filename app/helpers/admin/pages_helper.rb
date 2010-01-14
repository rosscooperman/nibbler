module Admin::PagesHelper
  def index_title(page)
    page.title
  end

  def index_actions(page)
    returning String.new do |out|
      out << link_to("Edit", edit_admin_page_path(page), :class => "button edit")
    end
  end
end
