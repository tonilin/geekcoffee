class User
  module OmniauthCallbacks

    def find_or_create_for_facebook(uid, data, credentials)

      if user = Authorization.where("provider" => "facebook", "uid" => uid).first.try(:user)
        user
      elsif user = User.find_by_email(data["email"])
        user.authorizations << Authorization.new(:provider => "facebook", :uid => uid )
        user.save
        return user
      else
        user = User.new_from_provider_data("facebook", uid, data, credentials)
        user.authorizations << Authorization.new(:provider => "facebook", :uid => uid )
        if user.save(:validate => false)
          return user
        else
          return nil
        end
      end

    end

    def new_from_provider_data(provider, uid, data, credentials)
      user = User.new
      user.email = data["email"]
      user.name = data["nickname"] ? data ["nickname"] : data["name"]      
      user.password = Devise.friendly_token[0,20]
      return user
    end
    
  end
end