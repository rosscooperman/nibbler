Factory.define :user do |u|
  u.username              { Faker::Internet.user_name }
  u.email                 { Faker::Internet.email }
  u.time_zone             "Eastern Time (US & Canada)"
  u.password              "yourface"
  u.password_confirmation "yourface"
  u.remember_token        'foo'
end

