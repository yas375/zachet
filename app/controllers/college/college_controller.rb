class College::CollegeController < ApplicationController
  layout 'college'

  helper_method :current_college

  private
  def current_college
    @current_college ||= College.find_by_subdomain(current_subdomain)
  end
end
