class Account::SettingsController < AuthenticatedController

  def index

  end

  def create
    if current_user.update(user_params)
      redirect_to :back, :notice => "成功更新資料"
    else
      render :index
    end

  end

  def edit_password

  end

  def update_password

    if current_user.update(user_password_params)
      sign_in current_user, :bypass => true
      redirect_to maps_path, :notice => "成功修改密碼"
    else
      render :edit_password
    end
  end


  private

  def user_params
    params.require(:user).permit(:name)
  end

  def user_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end


end
