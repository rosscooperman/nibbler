# == Schema Information
#
# Table name: trucks
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  description   :text
#  city          :string(255)
#  state         :string(255)
#  source        :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  source_data   :text
#  bounds_ne_lat :float
#  bounds_ne_lng :float
#  bounds_sw_lat :float
#  bounds_sw_lng :float
#

require 'spec_helper'

describe Truck do
  before do
    @truck = Factory(:truck)
  end

  context "#has_bounds?" do

    it "should return false if no bounds parameters are set" do
      @truck.has_bounds?.should be_false
    end

    it "should return true if all bounds parameters are set" do
      @truck.update_attributes(
        bounds_ne_lat: 40.0,
        bounds_ne_lng: -120.0,
        bounds_sw_lat: 39.0,
        bounds_sw_lng: -121.0
      )
      @truck.has_bounds?.should be_true
    end

    it "should return false if some (but not) all bounds parameters are set" do
      @truck.update_attributes(:bounds_ne_lat => 40.0)
      @truck.has_bounds?.should be_false
    end
  end


  context "#bounds" do

    it "should return nil if no bounds attributes are set" do
      @truck.bounds.should be_nil
    end

    it "should return nil if some (but not all) bounds attributes are set" do
      @truck.update_attributes(:bounds_ne_lat => 40.0)
      @truck.bounds.should be_nil
    end

    it "should return a 2x array if all bounds attributes are set" do
      @truck.update_attributes(
        bounds_ne_lat: 40.0,
        bounds_ne_lng: -120.0,
        bounds_sw_lat: 39.0,
        bounds_sw_lng: -121.0
      )
      @truck.bounds.should == [ [40.0, -120.0], [39.0, -121.0]]
    end
  end
end
