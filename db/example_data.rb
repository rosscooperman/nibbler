module FixtureReplacement
  attributes_for :contact_submission do |t|
    t.name    = random_string
    t.email   = random_email
    t.subject = random_string
    t.body    = random_string
  end

  attributes_for :user do |u|
    pw = random_string

    u.username              = random_string
    u.email                 = random_email
    u.password              = pw
    u.password_confirmation = pw
  end

  attributes_for :example_admin, :class => Administrator do |admin|
    admin.username              = "admin"
    admin.email                 = "admin@example.com"
    admin.password              = "password"
    admin.password_confirmation = "password"
  end

  attributes_for :page

  def random_email
    "#{random_string}@#{random_string}.com"
  end
end
