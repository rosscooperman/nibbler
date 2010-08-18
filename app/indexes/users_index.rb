class UsersIndex < IndexView::Base
  column :email
  column :edit do |admin|
    returning String.new do |text|
      text << link_to("Edit", edit_admin_user_path(admin))
      text << "&nbsp;"

      unless current_user == admin
        text << link_to("Remove", admin_user_path(admin), :method => :delete)
      end
    end
  end

  def target_class
    UserView
  end

  def default_sort_term
    :email
  end
end