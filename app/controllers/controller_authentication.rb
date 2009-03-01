module ControllerAuthentication
private

  def authenticate
    self.current_user = User.authenticate(params[:session][:email], params[:session][:password])
  end

  def remember_me
    if logged_in?
      if params[:session][:remember_me] == "1"
        self.current_user.remember_me!

        cookies[:auth_token] = {
          :value => self.current_user.remember_token,
          :expires => self.current_user.remember_token_expires_at
        }
      end
    end
  end
end

