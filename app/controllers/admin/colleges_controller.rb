# -*- coding: utf-8 -*-
class Admin::CollegesController < Admin::AdminController
  def new
     @college = College.new
  end

  def create
    @college = College.new(params[:college])
    if @college.save
      flash[:notice] = "ВУЗ #{@college.abbr} успешно добавлен"
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def index
    @colleges = College.all
  end

  def show
    @college = College.find(params[:id])
  end

  def edit
    @college = College.find(params[:id])
  end

  def update
    @college = College.find(params[:id])

    if @college.update_attributes(params[:college])
      flash[:notice] = "ВУЗ успешно обновлен"
      redirect_to :action => :show
    else
      render :action => :edit
    end
  end

  def destroy
    @college = College.find(params[:id])
    @college.destroy

    redirect_to :action => :index
  end
end
