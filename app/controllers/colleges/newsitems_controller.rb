class Colleges::NewsitemsController < ApplicationController
  def index
    @colleges/newsitems = Colleges::Newsitem.all
  end
  
  def show
    @colleges/newsitem = Colleges::Newsitem.find(params[:id])
  end
  
  def new
    @colleges/newsitem = Colleges::Newsitem.new
  end
  
  def create
    @colleges/newsitem = Colleges::Newsitem.new(params[:colleges/newsitem])
    if @colleges/newsitem.save
      flash[:notice] = "Successfully created colleges/newsitem."
      redirect_to @colleges/newsitem
    else
      render :action => 'new'
    end
  end
  
  def edit
    @colleges/newsitem = Colleges::Newsitem.find(params[:id])
  end
  
  def update
    @colleges/newsitem = Colleges::Newsitem.find(params[:id])
    if @colleges/newsitem.update_attributes(params[:colleges/newsitem])
      flash[:notice] = "Successfully updated colleges/newsitem."
      redirect_to @colleges/newsitem
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @colleges/newsitem = Colleges::Newsitem.find(params[:id])
    @colleges/newsitem.destroy
    flash[:notice] = "Successfully destroyed colleges/newsitem."
    redirect_to colleges/newsitems_url
  end
end
