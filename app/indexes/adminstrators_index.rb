class AdminstratorsIndex < IndexView::Base
  column :email
  column :edit do |admin|
    String.new.tap do |text|
      text << link_to("Edit", edit_admin_administrator_path(admin))
      text << "&nbsp;"

      unless current_user == admin
        text << link_to("Remove", admin_administrator_path(admin), :method => :delete)
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