ActiveAdmin.register Page do

  index do
    column :title
    column :slug
    default_actions
  end

  filter :title
  filter :slug

  show :title => :title do
    attributes_table do
      row :title
      row :slug
      row :body
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :slug
      f.input :body
    end
    f.buttons
  end

end
