class CreateUserView < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      create or replace view user_view AS (
        select *
        from users
        where
          users.type = "User" OR users.type IS NULL
      )
    SQL
  end

  def self.down
    execute "drop view user_view"
  end
end
