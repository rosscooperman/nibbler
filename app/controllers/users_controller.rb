class UsersController < ApplicationController
  make_resourceful do
    actions(:all)

    response_for(:create) do
      self.current_user = @user
      redirect_to root_path
    end
  end
  
  def index
    #@users = User.find(:all, :order => "ASC").paginate :per_page => 20, :page => params[:page]
  end

  def new
    respond_to do |format|
      format.html { render :layout => "application" }
    end
  end
end
