module MenuBuilderHelpers
  def build_menu(*items)
    items.map do |item|
      if !item[3] || current_user.send(item[3])
        %Q{<li#{ ' class="active"' if @current_tab == item[0] }>#{link_to(item[1], item[2])}</li>}
      end
    end.join
  end

  def build_tiered_menu(items)
    li_elements = []

    returning "" do |out|
      items.each do |item|
        li_elements << build_li_for(item)
      end

      out << content_tag(:ul, li_elements, :class => "nav_01")
    end
  end

  def build_li_for(item)
    tab, text, url, subtabs = item

    if url.is_a?(Array)
      url, html_options = url[0], url[1]
    else
      html_options = {}
    end

    li_class = @current_tab == tab ? "active" : ""
    li_content = link_to(text, url, html_options)

    subtab_li_elements = []

    if subtabs
      subtabs.each do |subtab_item|
        subtab_li_elements << build_li_for(subtab_item)
      end

      li_content += content_tag('ul', subtab_li_elements)
    end

    content_tag(:li, li_content, :class => li_class)
  end
end
