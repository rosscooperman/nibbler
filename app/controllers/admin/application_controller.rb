class Admin::ApplicationController < ActionController::Base
  include SharedControllerBehavior

  before_filter :login_required
  before_filter :login_from_cookie
  before_filter :admin_login_required

  filter_parameter_logging :password

private

  def admin_login_required
    unless current_user && current_user.admin?
      authorization_denied
    end
  end
end
