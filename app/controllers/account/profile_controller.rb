# -*- coding: utf-8 -*-
class Account::ProfileController < Account::AccountController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Для завершения регистрации, Вам необходимо проследовать по ссылке из письма, которое мы вам отправили на #{@user.email}"
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Данные обновлены"
      redirect_to root_url
    else
      render :action => :edit
    end
  end
end
