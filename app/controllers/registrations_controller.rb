class RegistrationsController < Devise::RegistrationsController





  def after_update_path_for(resource)
    maps_path
  end

end