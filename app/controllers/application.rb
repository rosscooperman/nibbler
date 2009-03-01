class ApplicationController < ActionController::Base
  include SharedControllerBehavior

  before_filter :login_from_cookie
  before_filter :save_return_to_state
end
