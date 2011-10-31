ActiveAdmin.register User do

  index do
    column :email
    column :type
    default_actions
  end

  filter :email

  show :title => :email do
    attributes_table do
      row :email
      row :created_at
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :type, :as => :select, :collection => ["User", "Administrator"], :include_blank => false
      f.input :time_zone
    end
    f.buttons
  end

end
