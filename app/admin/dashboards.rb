ActiveAdmin::Dashboards.build do

  section "Recently Added Trucks" do
    table_for Truck.order('created_at DESC').limit(5) do
      column :name do |truck|
        link_to truck.name, [ :admin, truck ]
      end
      column :locations do |truck|
        truck.locations.count.to_s
      end
      column :data_points do |truck|
        truck.data_points.count.to_s
      end
    end
  end
end
