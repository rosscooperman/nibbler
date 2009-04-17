class Admin::UsersController < Admin::ApplicationController
  before_filter { |c| c.current_tab = :users }
  
  make_resourceful do
    actions :all
  end

  def index
    reset_sortable_columns
    %w[users.username users.email users.created_at ].each {|column| 
      add_to_sortable_columns('users', column)
    }
    order = sortable_order('users', :field => "users.username", :sort_direction => :desc)

    options = { :order => order, :page => params[:page], :per_page => 50 }

    @users = if params[:search]
      fields = %w[username email]
      User.paginate options.merge(:conditions => [fields.map {|f| "#{f} LIKE ?" }.join(" OR "), *[["%#{params[:search]}%"] * fields.size].flatten])
    else
      User.paginate options
    end
  end
end