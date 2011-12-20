ActiveAdmin.register Truck do

  index do
    column :name
    column :description
    column 'Data Points' do |truck|
      truck.data_points.count.to_s
    end
    column 'Locations' do |truck|
      truck.locations.count.to_s
    end
    default_actions
  end

  show :title => :name do
    attributes_table do
      row :name
      row :description
      row :city
      row :state
      row('Source') { truck.source.gsub(/^Collector::/, '') }
      row :updated_at
      row :created_at
      row :source_data
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :city
      f.input :state, :as => :select, :collection => { 'New York' => 'NY' }
      f.input :source, :as => :select, :collection => { 'Twitter' => 'Collector::Twitter' }
      f.input :source_data, :as => :string, :hint => 'Twitter handle, Facebook username, etc.'
    end
    f.buttons
  end
end
