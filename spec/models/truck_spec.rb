# == Schema Information
#
# Table name: trucks
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#  city        :string(255)
#  state       :string(255)
#  source      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  source_data :text
#

require 'spec_helper'

describe Truck do
end
