if Rails.env.staging? || Rails.env.development?
  unless Administrator.count > 0
    Administrator.create!(:email => "admin@example.com", :password => "password", :password_confirmation => "password")
  end
end