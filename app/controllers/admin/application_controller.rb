class Admin::ApplicationController < ActionController::Base
  include SharedControllerBehavior
  
  before_filter :login_required unless RAILS_ENV == 'test'
  before_filter :login_from_cookie

  # before_filter :ensure_is_admin

  filter_parameter_logging :password

  helper :breadcrumbs
  
  attr_accessor :current_tab
  
  layout "application"
  

protected
  def ensure_is_admin
    unless current_user && current_user.admin?
      authorization_denied
    end
  end
end