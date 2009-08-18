module BreadcrumbsHelper
  
  def build_breadcrumb(*crumbs)
    crumb_lis = []
    crumbs.each do |crumb|
      crumb_lis << if (crumbs.last == crumb) || !crumb.is_a?(Array)
        crumb.is_a?(Array) ? crumb.first.to_s : crumb.to_s
      else
        link_to(crumb.first, crumb.last)
      end
    end
    crumbs = crumb_lis.join(breadcrumb_arrow)
    @crumbs = content_tag(:div, content_tag(:p, crumbs), :class => 'breadcrumbs') unless crumbs.blank?
  end
  
  def users_breadcrumb(*extra_crumbs)
    build_breadcrumb(*([
      ["Users", admin_users_path]
    ] + extra_crumbs))
  end

  def pages_breadcrumb(*extra_crumbs)
    build_breadcrumb(*([
      ["Pages", admin_pages_path]
    ] + extra_crumbs))
  end

  def breadcrumb_arrow
    image_tag "admin/breadcrumb_arrow.png", :alt => ""
  end
  
end
