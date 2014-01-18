# -*- encoding : utf-8 -*-
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(*providers)
    providers.each do |provider|
      class_eval %Q{
        def #{provider}
          auth = env["omniauth.auth"]

          if !current_user.blank?
            binding = User.find_binding(auth)
            current_user.bind_service(auth) if !binding #Add an auth to existing
            redirect_to setting_path, :notice => "Bind #{provider} account successfully."
          else
            binding = User.find_binding(auth)
            if binding.present?
              sign_in_and_redirect binding.user, :event => :authentication, :notice => "Signed in successfully."
            else
              @user = User.find_or_create_for_#{provider}(auth)
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