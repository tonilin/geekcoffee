module Admin::UsersHelper

  def render_admin_user_name(user)
    user.name
  end


  def render_admin_user_email(user)
    user.email
  end


end
