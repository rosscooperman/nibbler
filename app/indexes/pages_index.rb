class PagesIndex < IndexView::Base
  column :title,
         :sortable => true,
         :link => lambda { |page| index_title(page) }
  column :actions,
         :link => lambda { |page| index_actions(page) }

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
