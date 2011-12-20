class CreateDataPoints < ActiveRecord::Migration
  def change
    create_table :data_points do |t|
      t.string :collector
      t.text :data

      t.timestamps
    end
  end
end
