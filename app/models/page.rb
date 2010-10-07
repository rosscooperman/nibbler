# == Schema Information
#
# Table name: pages
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  header     :string(255)
#  body       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Page < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :slug
  validates_presence_of :body
  validates_uniqueness_of :slug
end

