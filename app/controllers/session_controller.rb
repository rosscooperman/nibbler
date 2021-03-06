class SessionController < ApplicationController
  include ControllerAuthentication

  helper ActiveAdmin::ViewHelpers::ActiveAdminApplicationHelper
  layout 'active_admin_logged_out'
  skip_before_filter :login_required

  def new
    respond_to do |format|
      format.html
    end
  end

  def create
    authenticate

    if logged_in?
      remember_me
      redirect_back_or_default(root_path)
    else
      flash_message(:sign_in, :problem)
      render :action => 'new'
    end
  end

  def destroy
    current_user.forget_me! if logged_in?
    cookies.delete :auth_token
    reset_session
    @current_user = nil
    flash_message(:sign_out, :success)

    if params[:return_to] && params[:return_to] !~ Regexp.new(signed_out_path)
      redirect_to params[:return_to]
    else
      redirect_to signed_out_url
    end
  end

  def forbidden
    # to html
  end

  def reset_password
    verify_reset_password_hash

    if request.post?
      if @user.update_attributes(params[:user])
        flash_message(:reset_password, :success)
        redirect_to root_url and return false
      else
        render :action => 'reset_password' and return false
      end
    end
  end

  def forgot_password
    if params[:user] && params[:user][:email]
      if user = User.find_by_email(params[:user][:email])
        user.send_password_reset_email
        flash_message(:forgot_password, :success)
        redirect_to new_session_url and return false
      else
        if request.post?
          flash_message(:forgot_password, :problem)
          redirect_to forgot_password_url and return false
        end
      end
    end
  end

private

  def verify_reset_password_hash
    @user = User.find(params[:id])
    unless @user.password_reset_hash == params[:hash]
      flash_message(:reset_password, :problem)
      redirect_to forgot_password_url and return false
    end

    self.current_user = @user
  end
end
