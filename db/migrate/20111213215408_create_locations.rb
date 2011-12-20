class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :truck_id
      t.float :lat
      t.float :lng
      t.datetime :starting_at
      t.datetime :ending_at
      t.text :source

      t.timestamps
    end
  end
end
