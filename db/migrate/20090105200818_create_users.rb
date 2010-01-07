class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :username
      t.string   :email
      t.string   :crypted_password, :limit => 40
      t.string   :salt,             :limit => 40
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :time_zone
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
