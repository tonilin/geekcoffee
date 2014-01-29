class Admin::FoursquaresController < AdminController

  def index
    @foursquares = Foursquare.recent.not_imported.paginate(:page => params[:page], :per_page => 25 )
  end

  def imported
    @foursquares = Foursquare.recent.imported.paginate(:page => params[:page], :per_page => 25 )
  end

  def create_shop
    @foursquare = Foursquare.find(params[:id])

    return head :no_content if !@foursquare || @foursquare.shop

    shop = @foursquare.build_shop
    shop.user = current_user
    shop.assign_value_from_foursquare(@foursquare)
    shop.save

    render :layout => nil
  end

end
