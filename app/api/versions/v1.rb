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
      requires :lat, :type => Float
      requires :lng, :type => Float
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

  resource :tokens do

    desc "Return Token"
    params do
      requires :email, :type => String
      requires :password, :type => String
    end
    post "create" do
      email = params[:email].downcase
      password = params[:password]
    
      @user = User.find_by_email(email)

      if @user.nil? # If user does not exist
        return error!("Invalid email or password.", 401)
      end

      if !@user.valid_password?(password)
        return error!("Invalid email or password.", 401)
      end

      @user.ensure_authentication_token
      @user.save

      present @user, :with => Entities::User
    end


  end




end