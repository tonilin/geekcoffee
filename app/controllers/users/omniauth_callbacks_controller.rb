# -*- encoding : utf-8 -*-
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    auth = env["omniauth.auth"]
    provider = auth["provider"]
    uid = auth["uid"]
    data = auth["info"]
    credentials = auth["credentials"]
    token = credentials["token"]

    if !current_user.blank?
      binding = User.find_binding(provider, uid)

      if binding.present?
        binding.refresh_token(token)
      else
        current_user.bind_service(provider, uid, token)
      end

      redirect_to setting_path, :notice => "Bind facebook account successfully."
    else
      @user = User.find_or_create_for_facebook(uid, data, token)
      sign_in_and_redirect @user, :event => :authentication, :notice => "Signed in successfully."
    end
  end


  # This is solution for existing accout want bind Google login but current_user is always nil
  # https://github.com/intridea/omniauth/issues/185                             
  def handle_unverified_request                                                 
    true                                                                        
  end 

end