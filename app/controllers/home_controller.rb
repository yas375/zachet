class HomeController < ApplicationController
  def index
    if params[:college_id] != 'helper'
      @college = College.find(params[:college_id])
      render :partial => 'index_college', :locals => {:college => @college}
    end
  end
end
