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

    desc "Return Shops by near"
    params do
      requires :lat, :type => Integer
      requires :lng, :type => Integer
      requires :distance, :type => Integer, :desc => "kilometres"
      optional :per_page, :type => Integer, :default => 100
      optional :page, :type => Integer, :default => 1
    end
    get "near" do
      @shops = Shop.near([params[:lat], params[:lng]], params[:distance], :units => :km).order("distance ASC")

      present @shops, :with => Entities::Shops
    end


    params do
      requires :id, :type => Integer
    end
    route_param :id do
      desc "Return Shop"

      get do
        @shop = Shop.find(params[:id])

        present @shop, :with => Entities::Shop
      end
    end



  end

end