class Admin::AdministratorsController < Admin::ApplicationController
  before_filter { |c| c.current_tab = :admins }

  make_resourceful do
    actions :new, :create, :edit, :update, :destroy

    response_for :create, :update, :destroy do
      redirect_to admin_administrators_path
    end
  end

  def index
    @index = AdminstratorsIndex.new(params)
    @administrators = @index.paginate
  end
end
