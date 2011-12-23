class TrucksController < ApplicationController

  def index
    @trucks = Truck.tire_search(params).reject { |truck| truck.locations.empty? }
  end
end
