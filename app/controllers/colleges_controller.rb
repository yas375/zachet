class CollegesController < ApplicationController
  layout 'college'
  def show
    @college = current_subdomain
  end

end
