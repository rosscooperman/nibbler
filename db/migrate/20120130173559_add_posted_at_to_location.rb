class AddPostedAtToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :posted_at, :datetime
  end
end
