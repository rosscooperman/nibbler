module AuthenticatedSystem
protected
  # Returns true or false if the user is logged in.
  # Preloads @current_user with the user model if they're logged in.
  def logged_in?
    current_user != :false
  end

  # Accesses the current user from the session.
  def current_user
    @current_user ||= (session[:user] && User.find_by_id(session[:user])) || :false
    @current_user
  end

  # Store the given user in the session.
  def current_user=(new_user)
    if new_user.nil? || new_user.is_a?(Symbol)
      session[:user] = nil
      @current_user = :false
    else
      session[:user] = new_user.id
      @current_user = new_user
    end
  end

  # Check if the user is authorized.
  #
  # Override this method in your controllers if you want to restrict access
  # to only a few actions or if you want to check if the user
  # has the correct rights.
  #
  # Example:
  #
  #  # only allow nonbobs
  #  def authorize?
  #    current_user.login != "bob"
  #  end
  def authorized?
    true
  end

  # Filter method to enforce a login requirement.
  #
  # To require logins for all actions, use this in your controllers:
  #
  #   before_filter :login_required
  #
  # To require logins for specific actions, use this in your controllers:
  #
  #   before_filter :login_required, :only => [ :edit, :update ]
  #
  # To skip this in a subclassed controller:
  #
  #   skip_before_filter :login_required
  #
  def login_required
    logged_in? && authorized? ? true : access_denied
  end

  # Redirect as appropriate when an access request fails.
  #
  # The default action is to redirect to the login screen.
  #
  # Override this method in your controllers if you want to have special
  # behavior in case the user is not authorized
  # to access the requested action.  For example, a popup window might
  # simply close itself.
  def access_denied
    respond_to do |accepts|
      accepts.html do
        store_location
        redirect_to sign_in_path
      end

      accepts.xml do
        headers["Status"]           = "Unauthorized"
        headers["WWW-Authenticate"] = %(Basic realm="Web Password")
        render :text => "Could't authenticate you", :status => '401 Unauthorized'
      end

      accepts.json do
        render :json => {
          :success => false,
          :errors  => "Must be logged in."
        }
      end
    end
    false
  end

  # Store the URI of the current request in the session.
  #
  # We can return to this location by calling #redirect_back_or_default.
  def store_location
    session[:return_to] = "http://#{request.host}:#{request.port}#{request.url}"
  end

  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.
  def redirect_back_or_default(default)
    url = session[:return_to] ? session[:return_to] : default
    respond_to do |accepts|
      accepts.html { redirect_to(url) }
    end
    session[:return_to] = nil
  end

  # Inclusion hook to make #current_user and #logged_in?
  # available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?
  end

  # When called with before_filter :login_from_cookie will check for an :auth_token
  # cookie and log the user back in if appropriate
  def login_from_cookie
    return unless cookies[:auth_token] && !logged_in?
    user = User.find_by_remember_token(cookies[:auth_token])
    if user && user.remember_token?
      user.remember_me!
      self.current_user = user
      cookies[:auth_token] = { :value => self.current_user.remember_token, :expires => self.current_user.remember_token_expires_at }
    end
  end
end
