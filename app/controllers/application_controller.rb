class ApplicationController < ActionController::Base
  protect_from_forgery

  def login_required
    if current_user.blank?
      store_location

      respond_to do |format|
        format.html  {
          authenticate_user!
        }
        format.js{
          render :partial => "common/not_logined"
        }
        format.all {
          head(:unauthorized)
        }
      end
    end
  
  end


  def require_is_admin
    store_location

    unless (current_user && current_user.admin?)
      redirect_to root_path, :flash => { :error => "no permission" }
    end
  end


  private

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath != "/users/password" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] = nil

    session[:previous_url] || maps_path
  end
  
end
