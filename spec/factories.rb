require 'support/spec_helpers'



FactoryGirl.define do

  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :random_string do |n|
    ('a'..'z').to_a.shuffle.join
  end

  factory :contact_submission do
    name    { FactoryGirl.generate(:random_string) }
    email   { FactoryGirl.generate(:email) }
    subject { FactoryGirl.generate(:random_string) }
    body    { FactoryGirl.generate(:random_string) }
  end

  factory :user do
    email                 { FactoryGirl.generate(:email) }
    password              { FactoryGirl.generate(:random_string) }
    password_confirmation { |user| user.password }
  end

  factory :example_admin, :class => Administrator do
    email                 "admin@example.com"
    password              "password"
    password_confirmation "password"
  end

  factory :page do
    title { FactoryGirl.generate(:random_string) }
    slug  { FactoryGirl.generate(:random_string) }
    body  { FactoryGirl.generate(:random_string) }
  end

end
