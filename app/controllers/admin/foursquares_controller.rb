class Admin::FoursquaresController < AdminController

  def index
    @foursquares = Foursquare.recent.paginate(:page => params[:page], :per_page => 25 )
  end

end
