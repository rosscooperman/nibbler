class PagesIndex < IndexView::Base
  column :title, :sortable => true do |page|
    index_title(page)
  end

  column :actions do |page|
    index_actions(page)
  end

  def target_class
    Page
  end

  def default_sort_term
    :title
  end

  def default_sort_direction
    :ASC
  end
end
