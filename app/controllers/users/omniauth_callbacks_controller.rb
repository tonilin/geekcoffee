# -*- encoding : utf-8 -*-
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(*providers)
    providers.each do |provider|
      class_eval %Q{
        def #{provider}
          auth = env["omniauth.auth"]
          provider = auth["provider"]
          uid = auth["uid"]
          data = auth["info"]
          credentials= auth["credentials"]


          if !current_user.blank?
            binding = User.find_binding(provider, uid)
            current_user.bind_service(provider, uid)
            redirect_to setting_path, :notice => "Bind #{provider} account successfully."
          else
            binding = User.find_binding(provider, uid)
            if binding.present?
              sign_in_and_redirect binding.user, :event => :authentication, :notice => "Signed in successfully."
            else
              @user = User.find_or_create_for_#{provider}(uid, data, credentials)
              sign_in_and_redirect @user, :event => :authentication, :notice => "Signed in successfully."
            end
          end
        end
      }
    end
  end
  
  provides_callback_for :facebook


  # This is solution for existing accout want bind Google login but current_user is always nil
  # https://github.com/intridea/omniauth/issues/185                             
  def handle_unverified_request                                                 
    true                                                                        
  end 

end