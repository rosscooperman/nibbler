module CronScripts
  class UpdateLocations < CronScripts::Base

    def initialize
    end

    def do_action
      Truck.order('updated_at ASC').limit(10).each do |truck|
        log "Finding new location(s) for '#{truck.name}'"
        truck.update_data_points
        truck.touch
      end
    end

    def log_name
      "update_locations.log"
    end

  end
end
