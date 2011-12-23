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

class Truck < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  has_many :data_points
  has_many :locations

  def update_data_points
    source.constantize.update(self)
  end

  def self.tire_search(params)
    tire.search(load: true) do
      query { string params[:q], default_operator: "AND" } if params[:q].present?
    end
  end
end
