class CreateTrucks < ActiveRecord::Migration
  def change
    create_table :trucks do |t|
      t.string :name
      t.text :description
      t.string :city
      t.string :state
      t.string :source

      t.timestamps
    end
  end
end
