class AddBoundingColumnsToTruck < ActiveRecord::Migration
  def change
    add_column :trucks, :bounds_ne_lat, :float
    add_column :trucks, :bounds_ne_lng, :float
    add_column :trucks, :bounds_sw_lat, :float
    add_column :trucks, :bounds_sw_lng, :float
  end
end
