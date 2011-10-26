class Admin::PagesController < Admin::ApplicationController
  before_filter { |c| c.current_tab = :pages }

  def index
    @index = PagesIndex.new(params)
    @pages = @index.paginate
  end
  
  def new
    @page = Page.new
  end

  # make_resourceful do
  #   actions :all
  # 
  #   response_for :create, :update do
  #     redirect_to admin_pages_path
  #   end
  # end

end