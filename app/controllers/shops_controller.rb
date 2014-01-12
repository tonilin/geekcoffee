class ShopsController < ApplicationController
  before_filter :login_required, :only => [:create, :new, :new_step2, :rating, :cancal_rating]


  def show
    @shop = Shop.find(params[:id])
    @page_type = "cafe"

    respond_to do |format|
      format.html do
        set_page_title @shop.name
        set_page_description @shop.description if @shop.description.present?
        set_page_image @shop.facebook_avatar if @shop.facebook_page?
      end
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
      redirect_to maps_path,  :flash => { :success => "成功建立咖啡館" }
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

  def rating
    @shop = Shop.find(params[:id])
    
    score = params[:score]

    if score.present?
      score = score.to_i

      if score <= 5 && score >= 0
        current_user.evaluate_shop(@shop, score)
      end
    end

    head :no_content
  end

  def cancel_rating
    @shop = Shop.find(params[:id])
  
    current_user.delete_shop_evaluation(@shop)


    head :no_content
  end


  private

  def shop_params
    params.require(:shop).permit(:name, :address, :phone, :lat, :lng, :description, :hours, :is_wifi_free, :power_outlets, :plug_price, :website_url)
  end


end