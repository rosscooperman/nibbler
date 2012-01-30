# == Schema Information
#
# Table name: locations
#
#  id          :integer(4)      not null, primary key
#  truck_id    :integer(4)
#  lat         :float
#  lng         :float
#  starting_at :datetime
#  ending_at   :datetime
#  source      :text
#  created_at  :datetime
#  updated_at  :datetime
#  posted_at   :datetime
#

class Location < ActiveRecord::Base
  belongs_to :truck
end
