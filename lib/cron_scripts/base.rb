module CronScripts
  class Base
    class OutputLogger < Logger
      def info(message)
        super
        puts message
      end
    end

    def self.run
      new.run
    end

    def run
      track_times do
        do_action
      end
    end

    def do_action
      raise NotImplementedError
    end

    def log_name
      raise NotImplementedError
    end

  private

    def log(message)
      logger.info(message)
    end

    def logger
      @logger ||= OutputLogger.new Rails.root.join("log", log_name)
    end

    def track_times
      log "===== Starting @ #{Time.now.utc} (UTC) ===="
      log ""
      yield
      log ""
      log "===== Ending @ #{Time.now.utc} (UTC) ====="
      log ""
      log ""
    end
  end
end
