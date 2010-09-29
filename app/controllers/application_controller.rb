class ApplicationController < ActionController::Base
  include SharedControllerBehavior

  before_filter :login_from_cookie
end
