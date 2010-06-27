class NewsitemsController < ApplicationController
  def index
    @newsitems = Newsitem.all
  end

  # GET /newsitems/1
  def show
    @newsitem = Newsitem.find(params[:id])
  end
end
