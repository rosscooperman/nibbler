# == Schema Information
#
# Table name: data_points
#
#  id         :integer(4)      not null, primary key
#  collector  :string(255)
#  data       :text
#  created_at :datetime
#  updated_at :datetime
#  truck_id   :integer(4)
#

require 'spec_helper'

describe DataPoint do
end
