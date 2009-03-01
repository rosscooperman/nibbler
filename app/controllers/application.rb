require File.dirname(__FILE__) + "/../helpers/list_forms"

class ApplicationController < ActionController::Base
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'c9da07f5d587b5917b6d39f307aa962c'

  include SharedControllerBehavior

  before_filter :login_from_cookie
end
