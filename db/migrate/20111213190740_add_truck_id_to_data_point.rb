class AddTruckIdToDataPoint < ActiveRecord::Migration
  def change
    add_column :data_points, :truck_id, :integer
  end
end
