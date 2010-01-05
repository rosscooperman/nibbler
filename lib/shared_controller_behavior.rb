module SharedControllerBehavior
  def self.included(controller)
    controller.class_eval do
      include Oink::MemoryUsageLogger
      include Oink::InstanceTypeCounter

      include AuthenticatedSystem
      include Authorization
      include FlashMessages

      helper_method :app_host
      helper :shared
      helper :images

      attr_accessor :current_tab

      filter_parameter_logging :password

      # See ActionController::RequestForgeryProtection for details
      # Uncomment the :secret if you're not using the cookie session store
      protect_from_forgery # :secret => 'c9da07f5d587b5917b6d39f307aa962c'
    end
  end

private

  def app_host
    SETTINGS[:app_host]
  end
end
