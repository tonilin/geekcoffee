class User
  module OmniauthCallbacks

    def find_or_create_for_facebook(response)
      uid = response["uid"]
      data = response["info"]
      credentials= response["credentials"]

      if user = User.find_by_fb_id(uid)
        return user
      elsif user = User.find_by_email(data["email"])
        user.update_attribute(:fb_id ,uid )
        return user
      else
        user = User.new_from_provider_data(provider, uid, data, credentials)

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
      user.token = credentials['token']
      user.name = data["nickname"] ? data ["nickname"] : data["name"]      
      user.password = Devise.friendly_token[0,20]
      user.fb_id = uid
      return user
    end
    
  end
end