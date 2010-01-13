class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.string :header
      t.string :body
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
