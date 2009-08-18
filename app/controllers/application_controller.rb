require File.dirname(__FILE__) + "/../helpers/list_forms"

class ApplicationController < ActionController::Base
  include SharedControllerBehavior

  before_filter :login_from_cookie
end
