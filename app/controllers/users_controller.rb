class UsersController < ApplicationController
  include VotingControllerLoader

  skip_before_filter :save_return_to_state

  make_resourceful do
    actions(:all)

    response_for(:create) do
      self.current_user = @user
      clear_anonymous_cookie_hash
      redirect_to root_path
    end
  end
  
  def new
    respond_to do |format|
      format.html { render :layout => "application" }
    end
  end
end
