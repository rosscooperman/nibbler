module CronScripts
  class UpdatePopularity < CronScripts::Base

    def initialize
    end

    def do_action
      Truck.all.each do |truck|
        log "Finding new location(s) for '#{truck.name}'"
        truck.update_data_points()
      end
    end

    def log_name
      "update_locations.log"
    end

  end
end
