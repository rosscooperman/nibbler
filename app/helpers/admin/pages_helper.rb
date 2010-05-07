module Admin::PagesHelper
  def index_title(page)
    page.title
  end

  def index_actions(page)
    returning String.new do |out|
      out << link_to("Edit",    edit_admin_page_path(page), :class => "button edit")
      out << link_to("Destroy", admin_page_path(page),
                                :class => "button delete",
                                :confirm => "Do you really want to delete #{page.title}",
                                :method => :delete
                    )
    end
  end
end
