class UsersController < ApplicationController
  make_resourceful do
    actions :create

    response_for :create do
      self.current_user = @user
      redirect_to root_path
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html { render :layout => "application" }
    end
  end
end
