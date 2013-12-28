class Admin::UsersController < AdminController

  def index
    @users = User.recent.paginate(:page => params[:page], :per_page => 25 )
  end

end
