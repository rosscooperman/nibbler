class AdminstratorsIndex < IndexView::Base
  column :email
  column :actions do |admin|
    String.new.tap do |text|
      text << link_to("Edit", edit_admin_administrator_path(admin), :class => "button edit")

      unless current_user == admin
        text << link_to("Remove", admin_administrator_path(admin), {
                          :method => :delete,
                          :class => "button delete",
                          :confirm => "Are you sure you want to delete this admin?  You'll lose *everything* associated with him!"
                        })
      end
    end
  end

  def target_class
    Administrator
  end

  def default_sort_term
    :email
  end
end