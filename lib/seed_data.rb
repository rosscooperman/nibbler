module SeedData
  extend self

  def seed
    create_admins
  end

  def create_admins
    if Rails.env.staging? || Rails.env.development?
      begin
        puts "* Creating example admin"
        create_example_admin
      rescue ActiveRecord::RecordInvalid
        puts "* Skipping creation of example admin"
      end
    end
  end
end