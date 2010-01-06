class Admin::UsersController < Admin::ApplicationController
  before_filter { |c| c.current_tab = :users }
  
  make_resourceful do
    actions :all
  end
end
