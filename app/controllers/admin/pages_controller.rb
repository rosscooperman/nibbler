class Admin::PagesController < Admin::ApplicationController
  before_filter { |c| c.current_tab = :pages }

  make_resourceful do
    actions :all

    response_for :create, :update do
      redirect_to admin_pages_path
    end
  end

  def index
    @index = PagesIndex.new(params)
    @pages = @index.paginate
  end
end