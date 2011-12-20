class AddSourceDataFieldToTruck < ActiveRecord::Migration
  def change
    add_column :trucks, :source_data, :text
  end
end
