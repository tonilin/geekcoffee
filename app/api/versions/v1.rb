class Versions::V1 < Grape::API
  version 'v1', :using => :path

  before do
    header "Access-Control-Allow-Origin", "*"
    header "Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT"
    header "Access-Control-Max-Age", "1728000"
  end

   helpers do
    def warden
      env['warden']
    end

    def current_user
      warden.user ||  User.find_by_authentication_token(params[:authentication_token])
    end
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

    desc "Login by email and password and Return Token"
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

      @user.ensure_authentication_token!
      @user.save

      present @user, :with => Entities::User
    end

    desc "Logout the user and reset the token"
    params do
      requires :authentication_token, :type => String
    end
    post "destroy" do
      return error!("401 Unauthorized.", 401) if !current_user

      current_user.reset_authentication_token!

      {}  # FIXME for 204 no content
    end


  end




end