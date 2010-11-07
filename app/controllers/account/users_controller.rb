class Account::UsersController < Account::AccountController
  def show
    @user = User.active.find(params[:id])
  end
end
