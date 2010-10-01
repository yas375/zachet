class UsersController < ApplicationController
  def show
    @user = User.active.find(params[:id])
  end
end
