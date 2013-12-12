class Admin::ShopsController < AdminController

  def index
    @shops = Shop.recent.paginate(:page => params[:page], :per_page => 25 )
  end

end
