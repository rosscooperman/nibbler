class Admin::AdministratorsController < Admin::ApplicationController
  before_filter { |c| c.current_tab = :admins }

  def index
    @index = AdminstratorsIndex.new(params)
    @administrators = @index.paginate
  end

  def new
    @administrator = Administrator.new
  end
  
  def create
    @administrator = Administrator.new(params[:administrator])
    if @administrator.save
      redirect_to admin_administrators_path, :notice => "Administrator created successfully"
    else
      render :new
    end
  end
  
  def edit
    @administrator = Administrator.find(params[:id])
  end
  
  def update
    @administrator = Administrator.find(params[:id])
    if @administrator.update_attributes(params[:administrator])
      redirect_to admin_administrators_path, :notice => "Administrator updated successfully"
    else
      render :edit
    end
  end

  def destroy
    @administrator = Administrator.find(params[:id])
    if @administrator.destroy
      redirect_to admin_administrators_path, :notice => "Administrator deleted successfully"
    else
      redirect_to admin_administrators_path, :alert => "Administrator could not be deleted"
    end
  end
end
