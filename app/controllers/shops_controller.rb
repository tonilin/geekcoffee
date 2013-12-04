class ShopsController < ApplicationController
  before_filter :login_required, :only => [:create, :new, :new_step2]


  def show
    @shop = Shop.find(params[:id])

    respond_to do |format|
      format.json do
        render :json => @shop, :serializer => ShopDetailSerializer, :root => false
      end
    end
  end


  def new
    @shop = Shop.new
  end

  def new_step2
    @shop = Shop.new(shop_params)
  end


  def create
    @shop = Shop.new(shop_params)
    @shop.user = current_user

    if @shop.save
      redirect_to root_path,  :flash => { :success => "成功建立咖啡館" }
    else
      render :new_step2
    end
  end

  def index
    respond_to do |format|
      format.json do
        render :json => Shop.all, :each_serializer => ShopSimpleSerializer
      end
    end


  end


  private

  def shop_params
    params.require(:shop).permit(:name, :address, :lat, :lng, :description, :hours, :is_wifi_free, :power_outlets, :plug_price)
  end


end