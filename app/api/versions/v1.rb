class Versions::V1 < Grape::API
  version 'v1', :using => :path


   helpers do
    def warden
      env['warden']
    end

    def current_user
      warden.user ||  User.find_by_authentication_token(params[:authentication_token])
    end

    def authenticate!
      error!(I18n.t('devise.failure.unauthenticated'), 401) unless current_user.present?
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

    desc "Create Shop"
    params do
      group :shop do
        requires :name, :type => String
        requires :phone, :type => String
        requires :website_url, :type => String
        optional :is_wifi_free, :type => Boolean
        optional :power_outlets, :type => Boolean
        optional :hours, :type => String
        optional :description, :type => String
        requires :lat, :type => Float
        requires :lng, :type => Float
        requires :address, :type => String
      end
    end
    post do
      authenticate!
      shop_param = ActionController::Parameters.new(params)
      shop_param = shop_param.require(:shop).permit(:name, :phone, :website_url, :is_wifi_free, :power_outlets, :hours, :description, :lat, :lng, :address)

      @shop = Shop.new(shop_param)

      if @shop.save
        return @shop
      else
        error!(@shop.errors, 400)
      end
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

  resource :users do

    desc "Sign up"
    params do
      requires :email, :type => String
      requires :password, :type => String
      requires :password_confirmation, :type => String
    end
    post "sign_up" do
      email = params[:email].downcase
      password = params[:password]
      password_confirmation = params[:password_confirmation]

      user = User.new
      user.email = email
      user.password = password
      user.password_confirmation = password_confirmation
      
      if user.save
        present user, :with => Entities::User
      else
        error!(user.errors.full_messages[0], 401)
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

        error!("Invalid email or password.", 401) if @user.nil?
        error!("Invalid email or password.", 401) if !@user.valid_password?(password)

        @user.ensure_authentication_token!
        @user.save

        present @user, :with => Entities::User
      end

      desc "Logout the user and reset the token"
      params do
        requires :authentication_token, :type => String
      end
      post "destroy" do
        authenticate!

        current_user.reset_authentication_token!

        {}  # FIXME for 204 no content
      end


    end
  end



end