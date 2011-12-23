class TrucksController < ApplicationController

  def index
    @trucks = Truck.tire_search(params)
  end
end
