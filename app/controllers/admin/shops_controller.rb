class Admin::ShopsController < AdminController
  before_filter :find_shop, :only => [:edit, :update]


  def index
    @shops = Shop.recent.paginate(:page => params[:page], :per_page => 25 )
  end

  def edit


  end

  def update
    if @shop.update(params.require(:shop).permit!)
      redirect_to admin_shops_path
    else
      render :edit
    end

  end

  private

  def find_shop
    @shop = Shop.friendly.find(params[:id])
  end

end
