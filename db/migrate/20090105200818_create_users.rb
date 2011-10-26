class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :email
      t.string   :crypted_password, :limit => 40
      t.string   :salt,             :limit => 40
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :time_zone, :default => "Eastern Time (US & Canada)"
      t.string   :type
      t.timestamps
    end

    add_index :users, :email
  end

  def self.down
    drop_table :users
  end
end
