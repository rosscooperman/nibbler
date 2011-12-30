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

class Truck < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  has_many :data_points
  has_many :locations

  tire do
    mapping do
      indexes :name,        type: 'string', analyzer: 'snowball', boost: 100
      indexes :description, type: 'string', analyzer: 'snowball', boost: 20
    end
  end

  def self.tire_search(params)
    tire.search(load: true) do
      query { string params[:q], default_operator: "AND" } if params[:q].present?
    end
  end

  def update_data_points
    source.constantize.update(self)
  end

  def has_bounds?
    [ bounds_ne_lat, bounds_ne_lng, bounds_sw_lat, bounds_sw_lng ].none?(&:blank?)
  end
end
