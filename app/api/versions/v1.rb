class Versions::V1 < Grape::API
  version 'v1', :using => :path

  before do
    header "Access-Control-Allow-Origin", "*"
    header "Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT"
    header "Access-Control-Max-Age", "1728000"
  end

  resource :shops do
    desc "Return Shops"
    params do
      optional :per_page, :type => Integer, :default => 100
      optional :page, :type => Integer, :default => 1
    end
    get do
      @shops = Shop.recent.paginate(:page => params[:page], :per_page => params[:per_page])

      present @shops, :with => Entities::Shops
    end

    desc "Return Shop"
    params do
        requires :id, :type => Integer
    end
    get ":id" do
      @shop = Shop.find(params[:id])

      present @shop, :with => Entities::Shop
    end

  end

end