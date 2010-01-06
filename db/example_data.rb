module FixtureReplacement
  attributes_for :contact_submission do |t|
    t.name    = random_string
    t.email   = random_email
    t.subject = random_string
    t.body    = random_string
  end

  def random_email
    "#{random_string}@#{random_string}.com"
  end
end