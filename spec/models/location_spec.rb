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
#

require 'spec_helper'

describe Location do
  pending "add some examples to (or delete) #{__FILE__}"
end
