class Admin::ApplicationController < ActionController::Base
  include SharedControllerBehavior

  before_filter :login_required
  before_filter :login_from_cookie

  filter_parameter_logging :password

  attr_accessor :current_tab

private

  def ensure_is_admin
    unless current_user && current_user.admin?
      authorization_denied
    end
  end
end
