class Admin::UsersController < Admin::ApplicationController
  before_filter { |c| c.current_tab = :users }

  def index
    @index = UsersIndex.new(params)
    @users = @index.paginate
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to admin_users_path, :notice => 'User created successfully'
    else
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to admin_users_path, :notice => 'User updated successfully'
    else
      render :edit
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to admin_users_path, :notice => 'User deleted successfully'
    else
      redirect_to admin_users_path, :alert => 'User could not be deleted'
    end
  end
end
