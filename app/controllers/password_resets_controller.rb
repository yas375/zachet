# -*- coding: utf-8 -*-
class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user

  def new
    render
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Инструкции по восстановлению пароля отправлены."
      redirect_to root_url
    else
      flash[:notice] = "Пользователь с таким email не найден"
      render :action => :new
    end
  end

  def edit
    render
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = "Пароль успешно сменён"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  private
  def load_user_using_perishable_token
    @user = User.email_equals(params['email'] || params['user']['email']).find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "Не получается найти вашу учетную запись. Попробуйте вручную скопировать адрес ссылки из письма и вставить в браузер. Если это недаст результата, то начните процесс восстановления пароля заново."
      redirect_to root_url
    end
  end
end
