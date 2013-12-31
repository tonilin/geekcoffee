class Api::ShopsController < APIController

  def index
    per_page = (params[:per_page] || 100).to_i

    if per_page <= 0
      return render :json => { :errors => "per_page should greater than zero" }, :status => 422
    end

    if per_page > 500
      return render :json => { :errors => "per_page should less than 500" }, :status => 422
    end

    @shops = Shop.recent.paginate(:page => params[:page], :per_page => per_page )

    return render :json => @shops, :each_serializer => ShopSimpleSerializer
  end

end
