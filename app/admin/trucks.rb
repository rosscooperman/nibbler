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
      row :source_data do
        pre truck.source_data
      end
      row :locations do
        div id: 'theMap'
      end
    end

    ul :class => 'coordinates', :style => 'display: none;' do
      truck.locations.each do |location|
        li "#{location.lat},#{location.lng}"
      end
    end
  end

  form partial: 'form'
end
