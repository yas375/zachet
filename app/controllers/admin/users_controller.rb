# -*- coding: utf-8 -*-
class Admin::UsersController < Admin::AdminController
  before_filter :set_current_navigation

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Пользователь #{@user.name} успешно добавлен"
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      flash[:notice] = "Пользователь успешно обновлен"
      redirect_to :action => :show
    else
      render :action => :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to :action => :index
  end

  private

  def set_current_navigation
    current_navigation :users
  end
end
