class Account::SettingsController < AuthenticatedController

  def index

  end

  def create
    if current_user.update(user_params)
      redirect_to :back
    else
      render :index
    end

  end


  def user_params
    params.require(:user).permit(:name)
  end


end
