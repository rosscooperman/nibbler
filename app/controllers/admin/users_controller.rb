class Admin::UsersController < Admin::ApplicationController
  before_filter { |c| c.current_tab = :users }
  
  make_resourceful do
    actions :all
  end
  
  def index
    # @index = UsersIndex.new(params)
    # @users = @index.paginate
  end
  
end
