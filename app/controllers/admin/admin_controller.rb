class Admin::AdminController < ApplicationController
  before_filter :require_user
  layout 'admin'

  private

  def find_college
    @college ||= College.find(params[:college_id])
  end
end
