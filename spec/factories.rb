require 'support/spec_helpers'
include SpecHelpers

FactoryGirl.define do

  factory :contact_submission do
    name    random_string
    email   random_email
    subject random_string
    body    random_string
  end

  factory :user do
    pw = random_string

    email    random_email
    password pw
    password pw
  end

  factory :example_admin, :class => Administrator do
    email                 "admin@example.com"
    password              "password"
    password_confirmation "password"
  end

  factory :page do
    title random_string
    slug  random_string
    body  random_string
  end
end
