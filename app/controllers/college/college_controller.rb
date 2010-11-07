# -*- coding: undecided -*-
class College::CollegeController < ApplicationController
  layout 'college'
  before_filter :find_college
  helper_method :current_college

  private
  def current_college
    @current_college ||= College.find_by_subdomain(current_subdomain)
  end

  def find_college
    raise ActiveRecord::RecordNotFound if current_college.nil?
  end
end
