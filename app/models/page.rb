class Page < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :slug
  validates_presence_of :body
  validates_uniqueness_of :slug
end

# == Schema Information
#
# Table name: pages
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#