# == Schema Information
#
# Table name: contact_submissions
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  email      :string(255)
#  subject    :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class ContactSubmission < ActiveRecord::Base
  validates_presence_of :name, :email, :subject, :body
  validates_format_of   :email, :with => Format::EMAIL
end
