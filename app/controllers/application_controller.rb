class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :setting_meta_tags

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
    unless (current_user && current_user.admin?)
      redirect_to root_path, :flash => { :error => "no permission" }
    end
  end


  private

  def setting_meta_tags

    set_meta_tags :site => Setting.app_name,
      :description => Setting.description,
      :keywords => Setting.keywords,
      :fb => {
        :app_id => Setting.facebook_app_id
      },
      :og => {
        :title => Setting.app_name,
        :description => Setting.description,
        :image => Setting.domain + Setting.default_logo_url,
        :url => request.original_url,
        :type => "website"
      },
      :reverse => true
  end


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
    previous_url = session[:previous_url]
    session[:previous_url] = nil

    previous_url || maps_path
  end
  
end
