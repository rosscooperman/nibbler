class Admin::UsersController < Admin::ApplicationController
  before_filter { |c| c.current_tab = :users }

  make_resourceful do
    actions :new, :create, :edit, :update, :destroy

    response_for :create, :update, :destroy do
      redirect_to admin_users_path
    end
  end

  def index
    @index = UsersIndex.new(params)
    @users = @index.paginate
  end
end
