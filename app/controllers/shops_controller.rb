class ShopsController < ApplicationController

  def new
    @shop = Shop.new
  end

  def new_step2
    @shop = Shop.new(shop_params)
  end


  def create
    @shop = Shop.new(shop_params)

    if @shop.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :address, :lat, :lng, :description, :hours, :is_wifi_free, :have_plugs, :plug_price)
  end


end